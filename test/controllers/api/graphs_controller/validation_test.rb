# frozen_string_literal: true

require 'test_helper'
require 'minitest/mock_expectations'

class Api::GraphsController::ValidationTest < ActionDispatch::IntegrationTest
  setup do
    sign_in(users(:owner))
    @graph = graphs(:simple)
    @data = { graph: { name: 'New Graph', state: { "health": 1 } } }
  end

  { owner: [:success, 1],
    admin: [:success, 1],
    editor: [:success, 1],
    viewer: [:forbidden, 0] }.each do |role, data|
    status, count = *data
    test "should validate graph #{role} with #{status}" do
      sign_in(users(role))
      assert_enqueued_jobs count, only: GraphValidationJob do
        post validate_api_graph_url(@graph, params: { validation_types: %i[structure dynamic] })
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

  test "should not validate with unallowed validation type" do
    assert_no_enqueued_jobs(only: GraphValidationJob) do
      post validate_api_graph_url(@graph, params: { validation_types: %i[structure hacked] })
    end
    assert_response :bad_request
    error = JSON.parse(response.body).deep_symbolize_keys
    assert_instance_of Hash, error[:error]
    assert_equal error[:error][:type], 'unallowed_types'
    assert_equal error[:error][:message], 'Validation types contain unallowed types'
    assert_equal error[:error][:unallowed_types], ['hacked']
    assert_equal error[:error][:allowed_types], %w[structure dynamic]
  end

  test "should validate without params" do
    assert_called_with(GraphValidationJob, :perform_later, [@graph, %i[structure dynamic]]) do
      post validate_api_graph_url(@graph)
    end
    assert_response :success
  end

  %i[structure dynamic].each do |type|
    test "should validate with #{type}" do
      assert_called_with(GraphValidationJob, :perform_later, [@graph, [type]]) do
        post validate_api_graph_url(@graph, params: { validation_types: [type] })
      end
      assert_response :success
    end
  end
end
