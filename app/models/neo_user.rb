class NeoUser
  include ActiveGraph::Node

  property :login
  property :name, type: String, default: "Joe"
  # probably, this one goes to NoeNode or smth
  #
  #I want an Array here
  # it doesnt like arrays
  # need to think
  #
  # and i want an inventory
  # but that would be second array
  #

  has_many :out, :neographs, rel_class: :NeoUG
  #should it have "has_many :in"" tho?

end