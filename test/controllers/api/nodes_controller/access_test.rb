# frozen_string_literal: true

require 'test_helper'

class Api::NodesController::AccessTest < ActionDispatch::IntegrationTest
  setup do
    sign_in(users(:owner))
    @node = nodes(:start)
    @graph = @node.graph
    @data = { node: { name: 'New node', text: 'example', html_x: 0, html_y: 0 } }
  end

  { editor: :success, owner: :success, admin: :success, viewer: :success }.each do |role, status|
    test "should show #{role} with #{status}" do
      sign_in(users(role))
      get api_graph_node_url(@graph, @node)
      assert_response status
    end
  end

  { editor: :success, owner: :success, admin: :success, viewer: :forbidden }.each do |role, status|
    test "should update #{role} with #{status}" do
      sign_in(users(role))
      patch api_graph_node_url(@graph, @node), params: @data
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
      assert_difference('Node.count', count) do
        delete api_graph_node_url(@graph, @node)
      end
      assert_response status
    end
  end
end
