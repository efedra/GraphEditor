# frozen_string_literal: true

require 'test_helper'

class Api::GraphsController::AccessTest < ActionDispatch::IntegrationTest
  setup do
    sign_in(users(:owner))
    @graph = graphs(:simple)
    @data = { graph: { name: 'New Graph', state: { "health": 1 } } }
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
    admin: [:forbidden, 0],
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
