# frozen_string_literal: true

require 'test_helper'

class Graph::NeoTest < ActiveSupport::TestCase

  test "can save node in neo" do
    n = NeoNode.create(kind: :start)
    assert_equal( :start, n.kind)
  end
end