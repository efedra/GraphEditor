# frozen_string_literal: true

require 'test_helper'

class GraphTest < ActiveSupport::TestCase
  setup do
    @graph = graphs(:complex)
  end

  test "should correctly count nodes" do
    assert_equal(@graph.nodes.count, 5)
  end

  test "should correctly count edges" do
    assert_equal(@graph.edges.count, 8)
  end
end
