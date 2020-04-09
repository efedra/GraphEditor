# frozen_string_literal: true

class Graph < ApplicationRecord
  has_many :nodes, dependent: :destroy
  belongs_to :user

  validates :name, :state, presence: true

  after_update_commit { GraphBroadcastJob.perform_later self, 'graph_update', as_json }
  after_destroy { GraphBroadcastJob.perform_later self, 'graph_destroy' }

  def edges
    Edge.where(start_id: nodes.select(:id))
      .or(Edge.where(finish_id: nodes.select(:id)))
  end

  # but it doesn't work:(
  def self.create_simple
    graph = new(name: 'Simple graph')
    start = graph.nodes.new(html_x: 0, html_y: 0, kind: :start)
    finish = graph.nodes.new(html_x: 0, html_y: 0, kind: :finish)
    start.output_edges.new(finish: finish)
    graph.save
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
end
