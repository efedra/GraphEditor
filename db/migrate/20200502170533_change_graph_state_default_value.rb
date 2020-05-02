# frozen_string_literal: true

class ChangeGraphStateDefaultValue < ActiveRecord::Migration[6.0]
  def change
    change_column_default :graphs, :state, from: "{}", to: {}
  end
end
