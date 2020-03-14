class HomeController < ApplicationController
  layout false
  def index

  end

  def new_graph
    n_nodes = 15
    n_edges = 20
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
    render json: {nodes: nodes, links: edges}
  end
end
