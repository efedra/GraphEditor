# frozen_string_literal: true
class NeoNode
  include ActiveGraph::Node

  property :title, type: String
  property :text, type: String, default: 'text'

  property :x, default: 0
  property :y, default: 0

  property :stroke, default: "none"
  property :strokeWidth, default: 1.5
  property :fill, default: "lightgreen"


  has_many :out, :neonodes, rel_class: :NeoEdge
  enum kind: %i[start finish inbetween]

end