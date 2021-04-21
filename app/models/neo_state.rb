class NeoState
  include ActiveGraph::Node

  property :ch_name, type: String, default: "Joe"

  property :stats, type: Hash, default: {hp: 100}

  # i want this one here. Can be removed tho.
  property :inventory, type: Hash

  # probably, this one goes to NoeNode or smth
  #
  # I want an Array here
  # it doesnt like arrays
  # need to think
  #
  # and i want an inventory
  # but that would be second array
  #

  # should it have "has_many :in"" tho?
  #


end