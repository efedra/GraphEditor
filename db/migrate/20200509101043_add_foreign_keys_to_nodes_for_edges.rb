# frozen_string_literal: true

class AddForeignKeysToNodesForEdges < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :edges, :nodes, column: :start_id
    add_foreign_key :edges, :nodes, column: :finish_id
  end
end
