# frozen_string_literal: true

class AddValidationInfoToGraph < ActiveRecord::Migration[6.0]
  def change
    add_column :graphs, :validation_info, :jsonb, null: false, default: {}
  end
end
