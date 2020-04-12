# frozen_string_literal: true

require 'test_helper'

class Api::MembersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @owner = users(:owner)
    @other = users(:other)
    sign_in(@owner)
    @graph = graphs(:simple)
    @data = { member: { user_id: @other.id, role: 'viewer' } }
  end

  test "should get index" do
    get api_graph_members_url(@graph)
    assert_response :success
  end

  test "should create" do
    assert_difference('@other.graphs.count', 1) do
      post api_graph_members_url(@graph), params: @data
    end
    assert_response :success
  end

  test "should not create invalid" do
    assert_difference('@other.graphs.count', 0) do
      post api_graph_members_url(@graph), params: { member:  {} }
    end
    assert_response 400
  end

  test "should not create invalid role" do
    assert_difference('@other.graphs.count', 0) do
      post api_graph_members_url(@graph), params: { member:  { user_id: @other.id, role: 'hacker' } }
    end
    assert_response :unprocessable_entity
  end

  test "should show" do
    @member = @graph.graphs_users.find_by(user: users(:editor))
    get api_graph_member_url(@graph, @member)
    assert_response :success
  end

  test "should not update urself" do
    @member = @graph.graphs_users.find_by(user: @owner)
    patch api_graph_member_url(@graph, @member), params: @data
    assert_response :not_found
  end

  test "should update other" do
    @member = @graph.graphs_users.find_by(user: users(:editor))
    patch api_graph_member_url(@graph, @member), params: @data
    assert_response :success
  end

  test "should not unsubscribe from your graph" do
    sign_in(@owner)
    assert_difference('@owner.graphs.count', 0) do
      delete unsubscribe_api_graph_members_path(@graph)
    end
    assert_response :forbidden
  end

  test "should unsubscribe from other graph" do
    sign_in(users(:editor))
    assert_difference('users(:editor).graphs.count', -1) do
      delete unsubscribe_api_graph_members_path(@graph)
    end
    assert_response :success
  end

  test "should destroy" do
    @member = @graph.graphs_users.find_by(user: users(:editor))
    assert_difference('users(:editor).count.count', -1) do
      delete api_graph_member_url(@graph, @member)
    end
    assert_response :success
  end
end
