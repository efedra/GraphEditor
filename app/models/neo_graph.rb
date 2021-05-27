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
  property :user_id, type: Integer
  #property :start_state, type: String


  has_one :out, :neostate, rel_class: :NeoGS

  #here was a very strange mistake.
  # TODO test again after fix
  # relations work even without has_one and has_many
  # so test.
  has_one :out, :neonode, rel_class: :NeoFirst

  #has_one :out, :neostate, rel_class: :NeoUG
end
