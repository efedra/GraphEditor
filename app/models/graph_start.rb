class GraphStart
  include ActiveGraph::Relationship


  property :text, type: String, default: ''

  from_class :NeoGraph
  to_class :NeoNode

  # it recognises "_to_class" but not "to_class"
  # but manual has "to_class"

  #has_one :in, :source_neonode
  #has_one :out, :dest_neonode


end