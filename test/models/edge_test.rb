# frozen_string_literal: true

require 'test_helper'

class EdgeTest < ActiveSupport::TestCase
  test 'invalid create with nodes from different graphs' do
    assert_raises ActiveRecord::RecordNotSaved do
      Edge.create!(text: "Test", weight: 1, start: nodes(:start), finish: nodes(:complex_start))
    end
  end
end
