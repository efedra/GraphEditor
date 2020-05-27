# frozen_string_literal: true

require 'test_helper'

class ActionParserTest < ActiveSupport::TestCase
  setup do
    @state = { a: false, x: 0, health: 5 }
    @parser = QuestEngine::ActionParser.new
  end

  test 'checks key in left hand side' do
    assert @parser.valid_action?(@state.keys, 'x = 0')
  end

  test 'checks not key in left hand side' do
    assert_not @parser.valid_action?(@state.keys, 'y = 0')
  end

  test 'checks key in right hand side' do
    assert @parser.valid_action?(@state.keys, 'x = health')
  end

  test 'checks not key in right hand side' do
    assert_not @parser.valid_action?(@state.keys, 'x = xhealth')
  end

  test 'checks valid math operation' do
    assert @parser.valid_action?(@state.keys, 'x = health + 1')
  end

  test 'checks invalid math operation' do
    assert_not @parser.valid_action?(@state.keys, 'x = xhealth $ 1')
  end

  test 'performs single action with number' do
    @parser.perform(@state, 'x =  1')
    assert_equal 1, @state[:x]
  end

  test 'performs sigle action with variable' do
    @parser.perform(@state, 'x =  health')
    assert_equal @state[:health], @state[:x]
  end

  test 'performs single action with +' do
    @parser.perform(@state, 'x =  1 + 1')
    assert_equal 2, @state[:x]
  end

  test 'performs single action with variable and operation' do
    @parser.perform(@state, 'x =  health - 1')
    assert_equal @state[:health] - 1, @state[:x]
  end
end
