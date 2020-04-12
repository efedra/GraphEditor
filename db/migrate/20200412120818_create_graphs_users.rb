# frozen_string_literal: true

class CreateGraphsUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :graphs_users do |t|
      t.belongs_to :user, foreign_key: true, index: true
      t.belongs_to :graph, foreign_key: true, index: true
      t.integer :scope, default: 0, null: false, index: true
      t.index %i[user_id graph_id], unique: true

      t.timestamps
    end
  end
end
