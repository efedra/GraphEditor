class ForceCreateNeoGraphUuidConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :NeoGraph, :uuid, force: true
  end

  def down
    drop_constraint :NeoGraph, :uuid
  end
end
