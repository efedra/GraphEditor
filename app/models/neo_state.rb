class NeoState
  include ActiveGraph::Node

  property :ch_name, type: String, default: "Joe"

  property :stats, type: Hash, default: {hp: 100}

  property :inventory, type: Hash

end