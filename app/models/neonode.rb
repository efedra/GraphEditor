class NeoNode
  include ActiveGraph::Node
  # probably, this one goes to NoeNode or smth
  #
  property :title
  property :text, default: 'text'

  #questionable
  # options are still strange. delete ":out,", so it shows error message
  has_many :out, :neonodes, rel_class: NeoEdge

  has_many :in, :neonodes, rel_class: NeoEdge

  enum type: [:start, :finish, :inbetween]
  # from manual:
  #   enum type: [:image, :video, :unknown]



end