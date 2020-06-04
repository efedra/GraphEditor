# frozen_string_literal: true

require 'test_helper'

class Graph::DynamicValidationTest < ActiveSupport::TestCase
  setup do
    @graph = graphs(:complex)
    @graph.update!(state: { x: 0 })
  end

  test "should invalid with no reachable node" do
    node = @graph.nodes.intermediate.create!(html_x: 0, html_y: 0)
    Edge.create!(start: @graph.nodes.start.first,
      finish: node,
      condition: 'x == 1',
      text: 'Edge cond')
    assert @graph.valid?
    assert_not @graph.valid?(:dynamic)
    error = @graph.errors.as_json
    assert_equal error[:dynamic][0][:type], :not_reachable_nodes
    assert_equal error[:dynamic][0][:message], 'Graph has not reachable nodes'
    assert_equal error[:dynamic][0][:not_reachable_nodes].to_a, [node.id]
  end

  test "should invalid with not used edges" do
    node = @graph.nodes.intermediate.create!(html_x: 0, html_y: 0)
    edge = Edge.new(start: @graph.nodes.start.first,
      finish: node,
      condition: 'x == 1',
      text: 'Edge cond')
    edge.save!
    Edge.create!(start: @graph.nodes.start.first,
      finish: node,
      condition: 'x == 0',
      text: 'Edge cond')
    assert @graph.valid?
    assert_not @graph.valid?(:dynamic)
    error = @graph.errors.as_json
    assert_equal error[:dynamic][0][:type], :not_used_edges
    assert_equal error[:dynamic][0][:message], 'Graph has not used edges'
    assert_equal error[:dynamic][0][:not_used_edges].to_a, [edge.id]
  end

  test "should invalid with cycles" do
    graph = graphs(:deadlock)
    graph.update!(state: { x: 0 })
    assert graph.valid?
    assert_not graph.valid?(:dynamic)
    error = graph.errors.as_json
    assert_equal error[:dynamic][0][:type], :cycles
    assert_equal error[:dynamic][0][:message], 'Graph has cycles'
    assert_equal error[:dynamic][0][:cycles].count, 1
    assert_equal error[:dynamic][0][:cycles][0][:start], nodes(:deadlock1).id
    assert_equal error[:dynamic][0][:cycles][0][:loops], 10
    assert_equal error[:dynamic][0][:cycles][0][:nodes].count, 3
    assert_equal error[:dynamic][0][:cycles][0][:nodes].to_set, [nodes(:deadlock2).id, nodes(:deadlock3).id, nodes(:deadlock1).id].to_set
    assert_equal error[:dynamic][0][:cycles][0][:nodes].count, 3
    assert_equal error[:dynamic][0][:cycles][0][:edges].to_set, [edges(:deadlock2).id, edges(:deadlock3).id, edges(:deadlock5).id].to_set
    assert_equal error[:dynamic][0][:cycles][0][:path].count, 1
    assert_equal error[:dynamic][0][:cycles][0][:path][0], node: nodes(:deadlock_start).id, edge: edges(:deadlock1).id
  end

  test "should invalid with terminal non finish" do
    int = @graph.nodes.intermediate.create!(html_x: 0, html_y: 0)
    Edge.create!(start: @graph.nodes.start.first,
      finish: int,
      condition: 'x == 0',
      text: 'deadlock5')
    edge = Edge.new(start: int,
      finish: @graph.nodes.finish.first,
      condition: 'x == 1',
      text: 'deadlock6')
    edge.save!
    assert @graph.valid?
    assert_not @graph.valid?(:dynamic)
    error = @graph.errors.as_json
    assert_equal error[:dynamic][0][:type], :not_used_edges
    assert_equal error[:dynamic][0][:message], 'Graph has not used edges'
    assert_equal error[:dynamic][0][:not_used_edges].to_a, [edge.id]
    assert_equal error[:dynamic][1][:type], :terminal_non_finish_nodes
    assert_equal error[:dynamic][1][:message], 'Graph has terminal nodes that no finish'
    assert_equal error[:dynamic][1][:terminal_non_finish_nodes].to_a, [int.id]
  end
end
