# frozen_string_literal: true

require 'test_helper'

class Api::MembersController::BaseTest < ActionDispatch::IntegrationTest
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
    assert_response :bad_request
  end

  test "should not create invalid role" do
    assert_difference('@other.graphs.count', 0) do
      post api_graph_members_url(@graph), params: { member:  { user_id: @other.id, role: 'hacker' } }
    end
    assert_response :unprocessable_entity
    error = JSON.parse(response.body).deep_symbolize_keys
    assert_instance_of Hash, error[:error]
    assert_equal error[:error][:type], 'validation_failed'
    assert_instance_of Hash, error[:error][:messages]
    assert_instance_of Array, error[:error][:messages][:role]
    role_error = error[:error][:messages][:role][0]
    assert_equal role_error[:type], 'invalid'
    assert_equal role_error[:message], 'Role "hacker" invalid. Available roles: admin, editor, viewer'
    assert_equal role_error[:role], 'hacker'
    assert_equal role_error[:avilable_roles], %w[admin editor viewer]
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

  test "should not update owner" do
    sign_in(users(:test))
    @member = @graph.graphs_users.find_by(user: users(:owner))
    patch api_graph_member_url(@graph, @member), params: @data
    assert_response :forbidden
  end

  test "should not destroy owner" do
    sign_in(users(:test))
    @member = @graph.graphs_users.find_by(user: users(:owner))
    delete api_graph_member_url(@graph, @member), params: @data
    assert_response :forbidden
  end

  test "should not unsubscribe from your graph" do
    sign_in(@owner)
    assert_difference('@owner.graphs.count', 0) do
      delete unsubscribe_api_graph_members_path(@graph)
    end
    assert_response :forbidden
    error = JSON.parse(response.body).deep_symbolize_keys
    assert_instance_of Hash, error[:error]
    assert_equal error[:error][:type], 'not_authorized'
    assert_equal error[:error][:message], 'not allowed to unsubscribe? this GraphsUser'
    assert_equal error[:error][:query], 'unsubscribe?'
    assert_equal error[:error][:model], 'GraphsUser'
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
    assert_difference('users(:editor).graphs.count', -1) do
      delete api_graph_member_url(@graph, @member)
    end
    assert_response :success
  end
end
