# frozen_string_literal: true

class CreateEdges < ActiveRecord::Migration[6.0]
  def change
    create_table :edges do |t|
      t.text :text
      t.float :weight
      t.references :start, null: false, references: :nodes
      t.references :finish, null: false, references: :nodes

      t.timestamps
    end
  end
end
