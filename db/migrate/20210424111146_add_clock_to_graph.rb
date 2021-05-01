class AddClockToGraph < ActiveRecord::Migration[6.0]
  def change
    add_column :graphs, :clock, :integer, default: 0, null: false
  end
end
