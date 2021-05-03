class ForceCreateNeoGsUuidConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :NeoGS, :uuid, force: true
  end

  def down
    drop_constraint :NeoGS, :uuid
  end
end
