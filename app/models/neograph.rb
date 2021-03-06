#
# TODO: Make it work(see more comments)
# it's more like a scheme now
# because this thing is obscure
#

class NeoGraph
  include ActiveGraph::Node
  # probably, this one goes to NoeNode or smth
  # 
  property :title
  property :text, default: 'text'



end
