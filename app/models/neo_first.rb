class NeoFirst
  include ActiveGraph::Relationship

  from_class :NeoGraph
  to_class :NeoNode

end