class ForceCreateNeoUgUuidConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :NeoUG, :uuid, force: true
  end

  def down
    drop_constraint :NeoUG, :uuid
  end
end
