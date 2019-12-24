class ModifyTables < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :graph, :text
  end
end
