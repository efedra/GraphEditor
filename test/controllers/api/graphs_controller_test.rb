# frozen_string_literal: true

require 'test_helper'

class Api::GraphsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @graph = graphs(:simple)
    @graph_data = { name: 'New Graph', state: '{"health: 1}' }
  end

  test "should get index" do
    get api_graphs_url
    assert_response :success
  end

  test "should create graph" do
    assert_difference('Graph.count') do
      post api_graphs_url, params: { graph:  @graph_data }
    end
    assert_response :success
  end

  test "should not create invalid graph" do
    assert_difference('Graph.count', 0) do
      post api_graphs_url, params: { graph:  {} }
    end
    assert_response 400
  end

  test "should show graph" do
    get api_graph_url(@graph)
    assert_response :success
  end

  test "should update graph" do
    patch api_graph_url(@graph), params: { graph: @graph_data }
    assert_response :success
  end

  test "should destroy graph" do
    assert_difference('Graph.count', -1) do
      delete api_graph_url(@graph)
    end
    assert_response :success
  end
end
