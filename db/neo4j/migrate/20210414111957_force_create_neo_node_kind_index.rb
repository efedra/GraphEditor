class ForceCreateNeoNodeKindIndex < ActiveGraph::Migrations::Base
  def up
    add_index :NeoNode, :kind, force: true
  end

  def down
    drop_index :NeoNode, :kind
  end
end
