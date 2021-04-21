class ForceCreateNeoFirstUuidConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :NeoFirst, :uuid, force: true
  end

  def down
    drop_constraint :NeoFirst, :uuid
  end
end
