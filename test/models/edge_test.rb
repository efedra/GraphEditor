# frozen_string_literal: true

require 'test_helper'

class EdgeTest < ActiveSupport::TestCase
  test 'invalid create with nodes from different graphs' do
    assert_raises ActiveRecord::RecordNotSaved do
      Edge.create!(text: "Test", weight: 1, start: nodes(:start), finish: nodes(:complex_start))
    end
  end

  test "invalid changes finish unreachable" do
    assert_raises ActiveRecord::RecordNotSaved do
      edges(:one_path_edge2).update!(finish: nodes(:one_path_start))
    end
  end

  test "invalid destroy finish unreachable" do
    assert_raises ActiveRecord::RecordNotDestroyed do
      edges(:one_path_edge2).destroy!
    end
  end
end
