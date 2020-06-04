# frozen_string_literal: true

require 'test_helper'

class EdgeTest < ActiveSupport::TestCase
  setup do
    @edge = edges(:first)
  end

  test 'invalid with nodes from different graphs' do
    edge = Edge.new(text: "Test", weight: 1, start: nodes(:start), finish: nodes(:complex_start))
    edge.save
    assert_not edge.valid?
    error = edge.errors.as_json
    assert_equal error[:base][0][:type], :nodes_belong_to_different_graphs
    assert_equal error[:base][0][:message], 'Start and finish nodes must belong to the same graph'
    assert_equal error[:base][0][:start], id: nodes(:start).id, graph_id: graphs(:simple).id
    assert_equal error[:base][0][:finish], id: nodes(:complex_start).id, graph_id: graphs(:complex).id
  end

  test 'invalid when action invalid' do
    @edge.action = 'coins = dollars'
    assert_not @edge.valid?
    error = @edge.errors.as_json
    assert_equal error[:action][0][:type], :invalid
    assert_equal error[:action][0][:message], 'Edge action invalid'
    assert_equal error[:action][0][:action], 'coins = dollars'
  end

  test 'invalid when condition invalid' do
    skip('Enable me when QuestEngine::ConditionParser is fixed')
    @edge.condition = 'coins + dollars > 2'
    assert_not @edge.valid?
    error = @edge.errors.as_json
    assert_equal error[:condition][0][:type], :invalid
    assert_equal error[:condition][0][:message], 'Edge condition invalid'
    assert_equal error[:condition][0][:condition], 'coins + dollars > 2'
  end
end
