class ForceCreateNeoUserUuidConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :NeoUser, :uuid, force: true
  end

  def down
    drop_constraint :NeoUser, :uuid
  end
end
