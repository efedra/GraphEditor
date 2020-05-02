# frozen_string_literal: true

require 'test_helper'

class GraphTest < ActiveSupport::TestCase
  setup do
    @graph = graphs(:complex)
  end

  test "should invalid with state:string" do
    @graph.state = "{a: 1}"
    assert_not @graph.valid?
  end

  test "should invalid with nested hash in state" do
    @graph.state = { a: 1, b: { c: 2 }, e: 3 }
    assert_not @graph.valid?
  end

  test "should correctly count nodes" do
    assert_equal(@graph.nodes.count, 5)
  end

  test "should correctly count edges" do
    assert_equal(@graph.edges.count, 8)
  end

  test "should invalid with two starts" do
    nodes(:complex_int1).start!
    assert @graph.valid?
    assert_not @graph.valid?(:graph_structure)
  end

  test "should invalid with no start" do
    nodes(:complex_start).destroy!
    assert @graph.valid?
    assert_not @graph.valid?(:graph_structure)
  end

  test "should invalid with no finish" do
    @graph.nodes.finish.destroy_all
    assert @graph.valid?
    assert_not @graph.valid?(:graph_structure)
  end

  # test "should invalid with no finish reachable" do
  #   @graph.nodes.finish.first.input_edges.destroy_all
  #   assert @graph.valid?
  #   refute @graph.valid?(:graph_structure)
  # end

  # test "should invalid with two components" do
  #   @graph.nodes.intermediate.create!(html_x: 0, html_y: 0)
  #   assert @graph.valid?
  #   refute @graph.valid?(:graph_structure)
  # end

  # test "should invalid with deadlocks" do
  #   graph = graphs(:deadlock)
  #   assert graph.valid?
  #   refute graph.valid?(:graph_structure)
  # end

  # test "should invalid with terminal non start" do
  #   int = @graph.nodes.intermediate.create!(html_x: 0, html_y: 0)
  #   int.input_edges.create!( text: 'deadlock5', weight: 1, start: nodes(:complex_start))
  #   assert @graph.valid?
  #   refute @graph.valid?(:graph_structure)
  # end
end
