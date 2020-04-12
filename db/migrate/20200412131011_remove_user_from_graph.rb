# frozen_string_literal: true

class RemoveUserFromGraph < ActiveRecord::Migration[6.0]
  def change
    remove_column :graphs, :user_id, :bigint
  end
end
