class Tmpnode
  include ActiveGraph::Node

  has_one :out, :tmpnode, rel_class: :tmprel

end