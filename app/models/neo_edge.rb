# the most questinable one
#
#
class NeoEdge
  include ActiveGraph::Relationship

  property :title, type: String
  property :text, type: String, default: 'text'

  # changes and requirements are described in an Array of Strings
  # Spaces are important!(for easier parsing later)
  property :requirements, type: Array, default: ["hp > 0"]
  property :changes, type: Array, default: ["hp + 0"]


  from_class :NeoNode
  to_class :NeoNode

  # it recognises "_to_class" but not "to_class"
  # but manual has "to_class"

  #has_one :in, :source_neonode
  #has_one :out, :dest_neonode


end
