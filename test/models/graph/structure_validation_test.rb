# frozen_string_literal: true

require 'test_helper'

class Graph::StructureValidationTest < ActiveSupport::TestCase
  setup do
    @graph = graphs(:complex)
  end

  test "should invalid with two starts" do
    nodes(:complex_int1).start!
    assert @graph.valid?
    assert_not @graph.valid?(:structure)
    error = @graph.errors.as_json
    assert_equal error[:structure][0][:type], :multiple_starts
    assert_equal error[:structure][0][:message], 'Graph has more than one start'
    assert_equal error[:structure][0][:start_nodes], @graph.nodes.start.pluck(:id)
  end

  test "should invalid with no start" do
    nodes(:complex_start).destroy!
    assert @graph.valid?
    assert_not @graph.valid?(:structure)
    error = @graph.errors.as_json
    assert_equal error[:structure][0][:type], :no_start
    assert_equal error[:structure][0][:message], 'Graph has no start node'
  end

  test "should invalid with no finish" do
    @graph.nodes.finish.destroy_all
    assert @graph.valid?
    assert_not @graph.valid?(:structure)
    error = @graph.errors.as_json
    assert_equal error[:structure][0][:type], :no_finish
    assert_equal error[:structure][0][:message], 'Graph has no finish node'
  end

  test "should invalid with no reachable node" do
    node = @graph.nodes.intermediate.create!(html_x: 0, html_y: 0)
    assert @graph.valid?
    assert_not @graph.valid?(:structure)
    error = @graph.errors.as_json
    assert_equal error[:structure][0][:type], :not_reachable_nodes
    assert_equal error[:structure][0][:message], 'Graph has not reachable nodes'
    assert_equal error[:structure][0][:not_reachable_nodes], [node.id]
  end

  test "should invalid with cycles" do
    graph = graphs(:deadlock)
    assert graph.valid?
    assert_not graph.valid?(:structure)
    error = graph.errors.as_json
    assert_equal error[:structure][0][:type], :cycles
    assert_equal error[:structure][0][:message], 'Graph has cycles'
    assert_equal error[:structure][0][:cycle_nodes][0].to_set, [nodes(:deadlock2).id, nodes(:deadlock3).id, nodes(:deadlock1).id].to_set
  end

  test "should invalid with terminal non finish" do
    int = @graph.nodes.intermediate.create!(html_x: 0, html_y: 0)
    int.input_edges.create!(text: 'deadlock5', weight: 1, start: nodes(:complex_start))
    assert @graph.valid?
    assert_not @graph.valid?(:structure)
    error = @graph.errors.as_json
    assert_equal error[:structure][0][:type], :terminal_non_finish_nodes
    assert_equal error[:structure][0][:message], 'Graph has terminal nodes that no finish'
    assert_equal error[:structure][0][:terminal_non_finish_nodes], [int.id]
  end
end
