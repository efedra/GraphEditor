# frozen_string_literal: true

class AddValidationDataToGraphs < ActiveRecord::Migration[6.0]
  def change
    add_column :graphs, :status, :integer, default: 0, null: false
    add_column :graphs, :validated_at, :datetime
    add_column :graphs, :validation_errors, :jsonb, null: false, default: {}
  end
end
