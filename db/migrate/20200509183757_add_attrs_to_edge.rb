# frozen_string_literal: true

class AddAttrsToEdge < ActiveRecord::Migration[6.0]
  def change
    add_column :edges, :action, :text, default: "", null: false
    add_column :edges, :condition, :text, default: "", null: false
  end
end
