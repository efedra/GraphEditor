# frozen_string_literal: true

class CreateNodes < ActiveRecord::Migration[6.0]
  def change
    create_table :nodes do |t|
      t.string :name
      t.text :text
      t.references :graph, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
