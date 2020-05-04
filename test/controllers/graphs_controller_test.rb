# frozen_string_literal: true

require 'test_helper'

class GraphsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get graphs_show_url
    assert_response :success
  end
end
