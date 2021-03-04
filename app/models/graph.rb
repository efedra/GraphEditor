# frozen_string_literal: true

class Graph < ApplicationRecord
  include LiberalEnum

  VALIDATION_TYPES = %i[
    structure
    dynamic
  ].freeze

  has_many :nodes, dependent: :destroy
  has_many :graphs_users, dependent: :destroy, inverse_of: :graph
  has_many :users, through: :graphs_users

  enum status: { undefined: 0, valid: 1, invalid: 2, pending: 3, processing: 4 }, _suffix: true

  validates :name, presence: true
  validate :state_is_json?
  validate :state_nested_json?

  with_options on: :structure do
    validate :one_start?
    validate :finishes?
    validate do |graph|
      Graph::StructureValidator.new(graph).validate
    end
  end

  with_options on: :dynamic do
    validate do |graph|
      Graph::DynamicValidator.new(graph).validate
    end
  end

  after_update_commit do
    GraphBroadcastJob.perform_later(self, 'graph_update', as_json) if saved_changes?
  end
  after_destroy { GraphBroadcastJob.perform_later self, 'graph_destroy', as_json }
  after_save_commit { users.each{|user| user.notify} }

  def owner
    users.find_by(graphs_users: { role: :owner })
  end

  def edges
    Edge.where(start_id: nodes.select(:id))
      .or(Edge.where(finish_id: nodes.select(:id)))
  end

  def as_json(options = {})
    super({ only: %i[id name nodes edges state] }.merge(options))
  end

  def clear_validation_info
    self.validation_info = {
      paths: []
    }
  end

  def self.simple(*args, **kwargs)
    graph = new(*args, **kwargs)
    graph.name ||= default(:name)
    graph
  end

  def self.create_simple!(*args, **kwargs)
    graph = simple(*args, **kwargs)
    graph.save!
    start = graph.nodes.start.simple
    start.save!
    finish = graph.nodes.finish.simple
    finish.save!
    Edge.simple(start: start, finish: finish).save!

    graph
  end

  def self.random_graph
    n_nodes = 10
    nodes = []
    (0..n_nodes).each do |id|
      nodes << {
        id: id,
        x: rand(800),
        y: rand(800)
      }
    end

    n_edges = 15
    edges = []
    (0..n_edges).each do |id|
      random_node = nodes.sample[:id]
      edges << {
        id: id,
        source: random_node,
        target: [(random_node + rand(3)).floor, n_nodes - rand(5)].min
      }
    end

    nodes[0][:label] = 'Start'
    nodes[0][:symbolType] = 'diamond'
    nodes[0][:color] = 'red'

    nodes[n_nodes - 1][:label] = 'Finish'
    nodes[n_nodes - 1][:symbolType] = 'star'
    nodes[n_nodes - 1][:color] = 'yellow'

    edges.reject! { |x| x[:source] == x[:target] }
    clean_edges = []
    edges.each do |edge|
      clean_edges << edge unless clean_edges.any? { |x| x[:source] == edge[:source] && x[:target] == edge[:target] }
    end
    { nodes: nodes, links: clean_edges }
  end

  def state_is_json?
    return if state.is_a? Hash

    api_error(:is_not_json,
      opts: { type: state.class },
      column: :state,
      state: {
        value: state,
        type: state.class.to_s
      })
    throw :abort
  end

  def state_nested_json?
    disallowed_types = [Hash] # maybe disallow arrays
    nested_disallowed = state.filter { |_, value| disallowed_types.include? value.class }
    return if nested_disallowed.blank?
    nested_disallowed = nested_disallowed.map { |key, value| { key: key, value: value, type: value.class.to_s } }
    api_error(:nested_json,
      column: :state,
      values: nested_disallowed)
  end

  def one_start?
    start_count = nodes.start.count
    return if start_count == 1
    api_error(:no_start, column: :structure) if start_count == 0
    api_error(:multiple_starts, column: :structure, start_nodes: nodes.start.pluck(:id)) if start_count > 1
    throw :abort
  end

  def finishes?
    api_error(:no_finish, column: :structure) if nodes.finish.count == 0
  end
end
