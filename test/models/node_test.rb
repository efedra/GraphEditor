# frozen_string_literal: true

require 'test_helper'

class NodeTest < ActiveSupport::TestCase
  setup do
    @graph = graphs(:simple)
  end

  test "invalid changes last start" do
    assert_raises ActiveRecord::RecordNotSaved do
      nodes(:start).intermediate!
    end
  end

  test "invalid destroy last start" do
    assert_raises ActiveRecord::RecordNotDestroyed do
      nodes(:graph_without_edges_start).destroy!
    end
  end

  test "invalid create second start" do
    assert_raises ActiveRecord::RecordNotSaved do
      @graph.nodes.start.create!(html_x: 0, html_y: 0)
    end
  end

  test "invalid changes second start" do
    assert_raises ActiveRecord::RecordNotSaved do
      @graph.nodes.intermediate.create!(html_x: 0, html_y: 0).start!
    end
  end

  test "invalid changes last finish" do
    assert_raises ActiveRecord::RecordNotSaved do
      nodes(:finish).intermediate!
    end
  end

  test "invalid destroy last finish" do
    assert_raises ActiveRecord::RecordNotDestroyed do
      nodes(:graph_without_edges_finish).destroy!
    end
  end

  test "invalid destroy finish unreachable" do
    assert_raises ActiveRecord::RecordNotDestroyed do
      nodes(:one_path_intermediate).destroy!
    end
  end
end
