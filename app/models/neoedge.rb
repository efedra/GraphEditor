# the most questinable one
#
#
class NeoEdge
  include ActiveGraph::Relationship


  from_class :NeoNode
  to_class :NeoNode

  # it recognises "_to_class" but not "to_class"
  # but manual has "to_class"

  #has_one :in, :source_neonode
  #has_one :out, :dest_neonode


end
