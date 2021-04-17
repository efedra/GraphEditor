# frozen_string_literal: true
class NeoNode
  include ActiveGraph::Node
  # probably, this one goes to NoeNode or smth
  #
  property :title, type: String
  property :text, type: String, default: 'text'


  has_many :out, :neonodes, rel_class: :NeoEdge
  enum kind: %i[start finish inbetween]
  # from manual:
  #   enum type: [:image, :video, :unknown]



end