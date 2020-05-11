# frozen_string_literal: true

require 'test_helper'

class Api::GraphsController::BaseTest < ActionDispatch::IntegrationTest
  setup do
    sign_in(users(:owner))
    @graph = graphs(:simple)
    @data = { graph: { name: 'New Graph', state: { "health": 1 } } }
  end

  test "should get index" do
    get api_graphs_url
    assert_response :success
  end

  test "should create graph" do
    assert_difference('Graph.count') do
      post api_graphs_url, params: @data
    end
    assert_response :success
  end

  test "should not create when parameter missing" do
    assert_difference('Graph.count', 0) do
      post api_graphs_url, params: { graph: {} }
    end
    assert_response :bad_request
    error = {
      error: {
        type: 'parameter_missing',
        message: 'Required parameter missing: graph',
        required_params: 'graph'
      }
    }.deep_stringify_keys
    assert_equal error, JSON.parse(response.body)
  end

  test "should not create when state string" do
    assert_difference('Graph.count', 0) do
      post api_graphs_url, params: { graph: { state: "string state" } }
    end
    assert_response :unprocessable_entity
    error = JSON.parse(response.body).deep_symbolize_keys
    assert_instance_of Hash, error[:error]
    assert_equal error[:error][:type], 'validation_failed'
    assert_instance_of Hash, error[:error][:messages]
    assert_instance_of Array, error[:error][:messages][:state]
    state_error = error[:error][:messages][:state][0]
    assert_equal state_error[:type], 'is_not_json'
    assert_equal state_error[:message], 'State type "String", but expected json-type'
    assert_equal state_error[:state], value: 'string state', type: 'String'
  end
end
