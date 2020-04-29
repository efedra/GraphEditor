# frozen_string_literal: true

class Graph < ApplicationRecord
  has_many :nodes, dependent: :destroy
  has_many :graphs_users, dependent: :destroy, inverse_of: :graph
  has_many :members, through: :graphs_users

  validates :name, :state, presence: true
  validate :state_contains_dub_keys?

  with_options on: :graph_structure do
    validate :one_start?
    validate :finishes?
    validate :any_finish_reachable?
    validate :one_component?
    validate :deadlocks?
    validate :terminal_non_finish?
  end

  after_update_commit { GraphBroadcastJob.perform_later self, 'graph_update', as_json }
  after_destroy { GraphBroadcastJob.perform_later self, 'graph_destroy' }

  before_create :state_contains_dub_keys?
  before_update :state_contains_dub_keys?

  def owner
    members.find_by(graphs_users: { role: :owner })
  end

  def edges
    Edge.where(start_id: nodes.select(:id))
      .or(Edge.where(finish_id: nodes.select(:id)))
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

  def state_contains_dub_keys?
    return unless state.scan(/"(.*?)"\s?:/).flatten.group_by { |x| x }.any? { |_k, v| v.size >= 2 }
    warnings.add(:state, warn('state.dup_keys'))
  end

  def one_start?
    start_count = nodes.start.count
    errors[:base] << error(:no_start) if start_count == 0
    errors[:base] << [:multiple_starts, error(:multiple_starts), nodes.start.pluck(:id)] if start_count > 1
  end

  def finishes?
    errors[:base] << error(:no_finish) if nodes.finish.count == 0
  end

  def any_finish_reachable?
    # errors[:base] << error(:no_reachable_finish)
  end

  def one_component?
    # errors[:base] << error(:multiply_components)
  end

  def deadlocks?
    # errors[:base] << error(:deadlocks)
  end

  def terminal_non_finish?
    # errors[:base]<< error(:terminal_non_finish)
  end
end

