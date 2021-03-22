# the most questinable one
#
#
class NeoEdge
  include ActiveGraph::Node
  # probably, this one goes to NoeNode or smth
  #
  property :title
  property :text, default: 'text'

  belongs_to :neonode


  has_one :in, :source_neonode
  has_one :out, :dest_neonode


end