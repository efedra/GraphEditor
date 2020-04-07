# frozen_string_literal: true

class AddAttrsToNode < ActiveRecord::Migration[6.0]
  def change
    add_column :nodes, :html_x, :integer
    add_column :nodes, :html_y, :integer
    add_column :nodes, :html_color, :string
    add_column :nodes, :kind, :integer, default: 0, null: false
    add_index :nodes, :kind
  end
end
