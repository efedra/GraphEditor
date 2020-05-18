# frozen_string_literal: true

require 'test_helper'

class Graph::BaseTest < ActiveSupport::TestCase
  setup do
    @graph = graphs(:complex)
  end

  test "should invalid with state:string" do
    @graph.state = '{health: 100}'
    assert_not @graph.valid?
    error = @graph.errors.as_json
    assert_equal error[:state][0][:type], :is_not_json
    assert_equal error[:state][0][:message], 'State type "String", but expected json-type'
    assert_equal error[:state][0][:state], value: '{health: 100}', type: 'String'
  end

  test "should invalid with nested json in state" do
    @graph.state = { items_count: 1, items: { carrot: 'used' }, health: 100 }
    assert_not @graph.valid?
    error = @graph.errors.as_json
    assert_equal error[:state][0][:type], :nested_json
    assert_equal error[:state][0][:message], 'State contains nested json'
    assert_equal error[:state][0][:values], [{ key: 'items', value: { 'carrot' => 'used' }, type: 'Hash' }]
  end

  test "should correctly count nodes" do
    assert_equal(@graph.nodes.count, 5)
  end

  test "should correctly count edges" do
    assert_equal(@graph.edges.count, 7)
  end
end
