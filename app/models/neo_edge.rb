# the most questinable one
#
#
class NeoEdge
  include ActiveGraph::Relationship

  property :title, type: String
  property :text, type: String, default: 'text'
  property :you_need, type: String, default:"hp>0"
  property :you_get, type: String, default: "hp+100"

  from_class :NeoNode
  to_class :NeoNode

end
