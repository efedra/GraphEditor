# frozen_string_literal: true

class AddUserToGraphs < ActiveRecord::Migration[6.0]
  def change
    add_reference :graphs, :user, foreign_key: true, index: true
  end
end
