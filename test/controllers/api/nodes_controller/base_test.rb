# frozen_string_literal: true

require 'test_helper'

class Api::NodesController::BaseTest < ActionDispatch::IntegrationTest
  setup do
    sign_in(users(:owner))
    @node = nodes(:start)
    @graph = @node.graph
    @data = { node: { name: 'New node', text: 'example', html_x: 0, html_y: 0 } }
  end

  test "should get index" do
    get api_graph_nodes_url(@graph)
    assert_response :success
  end

  test "should create" do
    assert_difference('Node.count') do
      post api_graph_nodes_url(@graph), params: @data
    end
    assert_response :success
  end

  test "should not create invalid" do
    assert_difference('Node.count', 0) do
      post api_graph_nodes_url(@graph), params: { node: {} }
    end
    assert_response :bad_request
  end
end
