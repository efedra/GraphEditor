class NeoState
  include ActiveGraph::Node

  property :stats, type: Hash, default: {}

end