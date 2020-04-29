# frozen_string_literal: true

require 'test_helper'

class Api::GraphsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in(users(:owner))
    @graph = graphs(:simple)
    @data = { graph: { name: 'New Graph', state: '{"health": 1}' } }
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

  test "should not create invalid graph" do
    assert_difference('Graph.count', 0) do
      post api_graphs_url, params: { graph: {} }
    end
    assert_response 400
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
