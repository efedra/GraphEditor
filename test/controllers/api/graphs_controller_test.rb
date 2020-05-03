# frozen_string_literal: true

require 'test_helper'

class Api::GraphsControllerTest < ActionDispatch::IntegrationTest
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

  { owner: [:success, 1],
    admin: [:success, 1],
    editor: [:success, 1],
    viewer: [:forbidden, 0] }.each do |role, data|
    status, count = *data
    test "should validate graph #{role} with #{status}" do
      sign_in(users(role))
      assert_enqueued_jobs count, only: GraphValidationJob do
        post validate_api_graph_url(@graph)
      end
      assert_response status
    end
  end

  test "should not validate when graph pending validation" do
    @graph.pending_status!
    assert_no_enqueued_jobs(only: GraphValidationJob) do
      post validate_api_graph_url(@graph)
    end
    assert_response :locked
    error = JSON.parse(response.body).deep_symbolize_keys
    assert_instance_of Hash, error[:error]
    assert_equal error[:error][:type], 'graph_locked'
    assert_equal error[:error][:message], 'Graph already pending validation'
    assert_equal error[:error][:graph_status], 'pending'
  end

  test "should not validate when graph in processing validation" do
    @graph.processing_status!
    assert_no_enqueued_jobs(only: GraphValidationJob) do
      post validate_api_graph_url(@graph)
    end
    assert_response :locked
    error = JSON.parse(response.body).deep_symbolize_keys
    assert_instance_of Hash, error[:error]
    assert_equal error[:error][:type], 'graph_locked'
    assert_equal error[:error][:message], 'Graph already in processing validation'
    assert_equal error[:error][:graph_status], 'processing'
  end

  { editor: :success, owner: :success, admin: :success, viewer: :success }.each do |role, status|
    test "should show #{role} with #{status}" do
      sign_in(users(role))
      get api_graph_url(@graph)
      assert_response status
    end
  end

  { editor: :success, owner: :success, admin: :success, viewer: :forbidden }.each do |role, status|
    test "should update #{role} with #{status}" do
      sign_in(users(role))
      patch api_graph_url(@graph), params: @data
      assert_response status
    end
  end

  { owner: [:success, -1],
    admin: [:success, -1],
    editor: [:forbidden, 0],
    viewer: [:forbidden, 0] }.each do |role, data|
    status, count = *data
    test "should destroy #{role} with #{status}" do
      sign_in(users(role))
      assert_difference('Graph.count', count) do
        delete api_graph_url(@graph)
      end
      assert_response status
    end
  end
end
