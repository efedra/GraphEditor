class ForceCreateNeoStateUuidConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :NeoState, :uuid, force: true
  end

  def down
    drop_constraint :NeoState, :uuid
  end
end
