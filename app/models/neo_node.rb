# frozen_string_literal: true
class NeoNode
  include ActiveGraph::Node

  property :title, type: String
  property :text, type: String, default: 'text'

  has_many :out, :neonodes, rel_class: :NeoEdge
  enum kind: %i[start finish inbetween]

end