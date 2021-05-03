class ForceCreateNeoNodeUuidConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :NeoNode, :uuid, force: true
  end

  def down
    drop_constraint :NeoNode, :uuid
  end
end
