# frozen_string_literal: true
class NeoNode
  include ActiveGraph::Node
  # probably, this one goes to NoeNode or smth
  #
  property :title, type: String
  property :text, type: String, default: 'text'

  #quable
  # options are still strange. delete ":out,", so it shows error message
  #has_many :out, :neonodes, rel_class: :NeoEdge

  #has_many :in, :neonodes, rel_class: :NeoEdge

  enum kind: %i[start finish inbetween]
  # from manual:
  #   enum type: [:image, :video, :unknown]



end