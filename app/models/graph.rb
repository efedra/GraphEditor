# frozen_string_literal: true

class Graph < ApplicationRecord
  has_many :nodes, dependent: :nullify

  validates :name, :state, presence: true

  def edges
    Edge.where(start_id: nodes.select(:id))
      .or(Edge.where(finish_id: nodes.select(:id)))
  end

  def self.random_graph
    n_nodes = 40
    n_edges = 80
    nodes = []
    edges = []
    (1..n_nodes).each do |id|
      nodes << {
          id: id,
          x: rand(800),
          y: rand(800)
      }
    end

    (1..n_edges).each do |id|
      random_node = nodes.sample[:id]
      edges << {
          id: id,
          source: random_node,
          target: [(random_node + rand(3)).floor, n_nodes - rand(5)].min
      }

      nodes[0][:label] = 'Start'
      nodes[0][:symbolType] = 'diamond'
      nodes[0][:color] = 'blue'


      nodes[n_nodes - 1][:label] = 'Finish'
      nodes[n_nodes - 1][:symbolType] = 'star'
      nodes[n_nodes - 1][:color] = 'yellow'

    end
    edges.reject! { |x| x[:source] == x[:target] }
    clean_edges = []
    edges.each do |edge|
      clean_edges << edge unless clean_edges.any?{|x| x[:source] == edge[:source] && x[:target] == edge[:target] }
    end
    {nodes: nodes, links: clean_edges}
  end
end
