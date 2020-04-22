require 'test_helper'
require 'quest_engine/engine'

class ConditionParserTest < ActiveSupport::TestCase
  setup do
    @state = {a: false, x: 0}
    @parser = ConditionParser.new
  end

  test 'checks zero delimiters' do
    assert_not @parser.send(:single_delimiter?, ' a 0')
  end
  test 'checks single delimiter' do
    assert @parser.send(:single_delimiter?, ' a > 0')
  end

  test 'checks multiple delimiters' do
    assert_not @parser.send(:single_delimiter?, ' a <> 0')
  end

  test 'should check valid condition' do
    assert @parser.valid_condition?(@state.keys, 'a == true')
  end

  test 'should find illegal character' do
    assert_not @parser.valid_condition?(@state.keys, 'a+~1>0')
  end

  test 'should find character not from keys' do
    assert_not @parser.valid_condition?(@state.keys, 'a + b > 2')
  end

  test 'should check false boolean condition' do
    assert_not @parser.allowed_condition?(@state, "a == #{!@state[:a]}")
  end

  test 'should check true boolean condition' do
    assert @parser.allowed_condition?(@state, "a == #{@state[:a]}")
  end

  test 'should check false math condition' do
    assert_not @parser.allowed_condition?(@state, "x + 1 == 2")
  end

  test 'should check true math condition' do
    assert @parser.allowed_condition?(@state, "x + 1 == 1")
  end
end