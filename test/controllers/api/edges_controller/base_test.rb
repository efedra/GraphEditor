# frozen_string_literal: true

require 'test_helper'

class Api::EdgesController::BaseTest < ActionDispatch::IntegrationTest
  setup do
    sign_in(users(:owner))
    @edge = edges(:first)
    @graph = @edge.graph
    @data = { edge: { name: 'New edge', start_id: nodes(:start).id, finish_id: nodes(:finish).id } }
  end

  test "should get index" do
    get api_graph_edges_url(@graph)
    assert_response :success
  end

  test "should create" do
    assert_difference('Edge.count') do
      post api_graph_edges_url(@graph), params: @data
    end
    assert_response :success
  end

  test "should not create invalid" do
    assert_difference('Edge.count', 0) do
      post api_graph_edges_url(@graph), params: { edge: {} }
    end
    assert_response :bad_request
  end

  test "should not create when nodes belong to different graphs" do
    assert_difference('Edge.count', 0) do
      params = {
        edge: {
          start_id: nodes(:start).id,
          finish_id: nodes(:complex_start).id
        }
      }
      post api_graph_edges_url(@graph), params: params
    end
    assert_response :unprocessable_entity
    error = JSON.parse(response.body).deep_symbolize_keys
    assert_instance_of Hash, error[:error]
    assert_equal error[:error][:type], 'validation_failed'
    assert_instance_of Hash, error[:error][:messages]
    assert_instance_of Array, error[:error][:messages][:base]
    base_error = error[:error][:messages][:base][0]
    assert_equal base_error[:type], 'nodes_belong_to_different_graphs'
    assert_equal base_error[:message], 'Start and finish nodes must belong to the same graph'
    assert_equal base_error[:start], id: nodes(:start).id, graph_id: graphs(:simple).id
    assert_equal base_error[:finish], id: nodes(:complex_start).id, graph_id: graphs(:complex).id
  end
end
