class NeoUG
  include ActiveGraph::Relationship



  from_class :NeoUser
  to_class :NeoGraph

end