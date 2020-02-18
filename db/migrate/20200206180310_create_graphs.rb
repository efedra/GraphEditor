# frozen_string_literal: true

class CreateGraphs < ActiveRecord::Migration[6.0]
  def change
    create_table :graphs do |t|
      t.string :name
      t.jsonb :state, null: false, default: '{}'

      t.timestamps
    end
  end
end
