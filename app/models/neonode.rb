class NeoNode
  include ActiveGraph::Node
  # probably, this one goes to NoeNode or smth
  #
  property :title
  property :text, default: 'text'

  #questionable
  # options are still strange. delete ":out,", so it shows error message
  has_many :out, :neoedges

  has_many :in, :neoedges

  enum type: [:start, :finish, :inbetween]
  # from manual:
  #   enum type: [:image, :video, :unknown]



end