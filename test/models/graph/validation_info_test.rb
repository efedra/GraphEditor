# frozen_string_literal: true

require 'test_helper'

class Graph::ValidationInfoTest < ActiveSupport::TestCase
  test "calculate simple path" do
    graph = graphs(:simple)
    assert graph.valid?(:dynamic)
    info = graph.validation_info
    assert_equal info[:paths].size, 1
    paths = info[:paths]
    assert_includes paths, [edges(:first).id]
  end

  test "calculate complex paths" do
    graph = graphs(:complex)
    assert graph.valid?(:dynamic)
    info = graph.validation_info
    assert_equal info[:paths].size, 2
    paths = info[:paths]
    # s -> f1
    assert_includes paths, [edges(:complex_edge1).id]
    # s -> i2 -> f2
    assert_includes paths, [edges(:complex_edge3).id, edges(:complex_edge7).id]
  end

  test "calculate complex dynamic paths" do
    graph = graphs(:complex)
    graph.update!(state: { x: 0 })
    edges(:complex_edge2).update!(action: 'x = x + 1')

    assert graph.valid?(:dynamic)
    info = graph.validation_info
    assert_equal info[:paths].size, 4
    paths = info[:paths]
    # s -> f1
    assert_includes paths, [edges(:complex_edge1).id]
    # s -> i2 -> f2
    assert_includes paths, [edges(:complex_edge3).id, edges(:complex_edge7).id]
    # s -> i1 -> f1
    assert_includes paths, [edges(:complex_edge2).id, edges(:complex_edge4).id]
    # s -> i1 -> i2 -> f2
    assert_includes paths, [edges(:complex_edge2).id, edges(:complex_edge6).id, edges(:complex_edge7).id]
  end
end
