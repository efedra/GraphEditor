# frozen_string_literal: true

require 'test_helper'

class Api::EdgesControllerTest < ActionDispatch::IntegrationTest
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
    assert_response 400
  end

  { editor: :success, owner: :success, admin: :success, viewer: :success }.each do |role, status|
    test "should show #{role} with #{status}" do
      sign_in(users(role))
      get api_graph_edge_url(@graph, @edge)
      assert_response status
    end
  end

  { editor: :success, owner: :success, admin: :success, viewer: :forbidden }.each do |role, status|
    test "should update #{role} with #{status}" do
      sign_in(users(role))
      patch api_graph_edge_url(@graph, @edge), params: @data
      assert_response status
    end
  end

  { owner: [:success, -1],
    admin: [:success, -1],
    editor: [:success, -1],
    viewer: [:forbidden, 0] }.each do |role, data|
    status, count = *data
    test "should destroy #{role} with #{status}" do
      sign_in(users(role))
      assert_difference('Edge.count', count) do
        delete api_graph_edge_url(@graph, @edge)
      end
      assert_response status
    end
  end
end
