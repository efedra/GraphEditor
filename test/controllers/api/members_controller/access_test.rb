# frozen_string_literal: true

require 'test_helper'

class Api::MembersController::AccessTest < ActionDispatch::IntegrationTest
  setup do
    @owner = users(:owner)
    @other = users(:other)
    sign_in(@owner)
    @graph = graphs(:simple)
    @data = { member: { user_id: @other.id, role: 'viewer' } }
  end

  { editor: :success, owner: :success, admin: :success, viewer: :success }.each do |role, status|
    test "should show #{role} with #{status}" do
      sign_in(users(role))
      member = @graph.graphs_users.find_by(user: users(:test))
      get api_graph_member_url(@graph, member)
      assert_response status
    end
  end

  { editor: :forbidden, owner: :success, admin: :success, viewer: :forbidden }.each do |role, status|
    test "should update #{role} with #{status}" do
      sign_in(users(role))
      member = @graph.graphs_users.find_by(user: users(:test))
      patch api_graph_member_url(@graph, member), params: @data
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
      member = @graph.graphs_users.find_by(user: users(:test))
      assert_difference('GraphsUser.count', count) do
        delete api_graph_member_url(@graph, member)
      end
      assert_response status
    end
  end

  { owner: [:forbidden, 0],
    admin: [:success, -1],
    editor: [:success, -1],
    viewer: [:success, -1] }.each do |role, data|
    status, count = *data
    test "should unsubscribe #{role} with #{status}" do
      sign_in(users(role))
      assert_difference('GraphsUser.count', count) do
        delete unsubscribe_api_graph_members_path(@graph)
      end
      assert_response status
    end
  end
end
