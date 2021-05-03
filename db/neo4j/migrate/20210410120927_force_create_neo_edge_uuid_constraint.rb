class ForceCreateNeoEdgeUuidConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :NeoEdge, :uuid, force: true
  end

  def down
    drop_constraint :NeoEdge, :uuid
  end
end
