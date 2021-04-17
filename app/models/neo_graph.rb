#
# TODO: Make it work(see more comments)
# /*some notes for myself mostly*/
# it's more like a scheme now
# because this thing is obscure
# that is strange, to say the least, with those :in and :out and graph being the node

class NeoGraph
  include ActiveGraph::Node
  # probably, this one goes to NoeNode or smth
  #
  property :title
  property :text, default: 'text'
  property :start_state, type: String


  has_many :out, :neonodes
  has_many :out, :neonedges
end
