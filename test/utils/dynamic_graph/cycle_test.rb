# frozen_string_literal: true

require 'test_helper'

# rubocop:disable Metrics/ClassLength
class DynamicGraph::CycleTest < ActiveSupport::TestCase
  setup do
    @graph = DynamicGraph.new
    @graph.config[:search_timeout] = 1
  end

  def assert_search_cycle(nodes, edges, state: { x: 0 }, status: :success)
    nodes.each { |n| @graph.add_vertex(n) }
    edges.each_with_index do |e, i|
      e[:id] ||= e[:start].to_s + e[:finish].to_s + i.to_s
      options = e.except(:start, :finish, :id)
      @graph.add_edge(e[:start], e[:finish], e[:id], options: options)
    end

    assert_nothing_raised do
      Timeout.timeout(4) do
        @graph.bfs_search_tree_from(:start, state)
      end
    end

    assert_equal @graph.status, status
    assert_equal nodes.to_set, @graph.nodes.to_set
    assert_equal edges.map { |e| e[:id] }.to_set, @graph.edges.to_set
  end

  test 'valid search loop-single cycle' do
    nodes = [:start]
    edges = [
      { start: :start, finish: :start, id: 0, action: 'x = x + 1' }
    ]

    assert_search_cycle nodes, edges

    assert_equal @graph.cycles.count, 1
    cycle = @graph.cycles.first
    assert_equal cycle[:start], :start
    assert_equal cycle[:nodes], [:start]
    assert_equal cycle[:edges], [0]
    assert_empty cycle[:path]
  end

  test 'valid search double cycle' do
    nodes = %i[start finish]
    edges = [
      { start: :start, finish: :finish, id: 0, action: 'x = x + 1' },
      { start: :finish, finish: :start, id: 1 }
    ]

    assert_search_cycle nodes, edges

    assert_equal @graph.cycles.count, 1
    cycle = @graph.cycles.first
    assert_equal cycle[:start], :start
    assert_equal cycle[:nodes].count, nodes.count
    assert_equal cycle[:nodes].to_set, nodes.to_set
    assert_equal cycle[:edges].count, edges.count
    assert_equal cycle[:edges].to_set, edges.map { |e| e[:id] }.to_set
    assert_empty cycle[:path]
  end

  test 'valid search simple triple cycle' do
    nodes = %i[start i f]
    edges = [
      { start: :start, finish: :i, id: 0, action: 'x = x + 1' },
      { start: :i, finish: :f, id: 1, action: 'x = x + 1' },
      { start: :f, finish: :start, id: 2, action: 'x = x + 1' }
    ]

    assert_search_cycle nodes, edges

    assert_equal @graph.cycles.count, 1
    cycle = @graph.cycles.first
    assert_equal cycle[:start], :start
    assert_equal cycle[:nodes].count, nodes.count
    assert_equal cycle[:nodes].to_set, nodes.to_set
    assert_equal cycle[:edges].count, edges.count
    assert_equal cycle[:edges].to_set, edges.map { |e| e[:id] }.to_set
    assert_empty cycle[:path]
  end

  test 'valid search simple cycle' do
    nodes = %i[start i c1 c2 c3]
    edges = [
      { start: :start, finish: :i, id: 0 },
      { start: :i, finish: :c1, id: 1, action: 'x = x + 1' },
      { start: :c1, finish: :c2, id: 2, action: 'x = x + 1' },
      { start: :c2, finish: :c3, id: 3, action: 'x = x + 1' },
      { start: :c3, finish: :c1, id: 4, action: 'x = x + 1' }
    ]

    assert_search_cycle nodes, edges

    assert_equal @graph.cycles.count, 1
    cycle = @graph.cycles.first
    assert_equal cycle[:start], :c1
    assert_equal cycle[:nodes].count, 3
    assert_equal cycle[:nodes].to_set, %i[c1 c2 c3].to_set
    assert_equal cycle[:edges].count, 3
    assert_equal cycle[:edges].to_set, [2, 3, 4].to_set
    assert_equal cycle[:path].count, 2
    path = cycle[:path]
    assert_equal path[0], node: :start, edge: 0
    assert_equal path[1], node: :i, edge: 1
  end

  test 'stop endless dynamic cycle by loop count' do
    nodes = %i[start c1 c2 c3 f]
    edges = [
      { start: :start, finish: :c1, id: 0 },
      { start: :c1, finish: :c2, id: 1 },
      { start: :c2, finish: :c3, id: 2 },
      { start: :c3, finish: :c1, id: 3, action: 'x = x + 1' },
      { start: :c2, finish: :f, id: 4, condition: 'x == 9' }
    ]

    @graph.config[:loop_max] = 10
    assert_search_cycle nodes, edges

    assert_equal @graph.cycles.count, 1
    cycle = @graph.cycles.first
    assert_equal cycle[:start], :c1
    assert_equal cycle[:nodes].count, 3
    assert_equal cycle[:nodes].to_set, %i[c1 c2 c3].to_set
    assert_equal cycle[:loops], 10
    assert_equal cycle[:edges].count, 3
    assert_equal cycle[:edges].to_set, [1, 2, 3].to_set
    assert_equal cycle[:path].count, 1
    path = cycle[:path]
    assert_equal path[0], node: :start, edge: 0
  end

  test 'stop endless dynamic cycle by timeout' do
    nodes = %i[start c1 c2]
    edges = [
      { start: :start, finish: :c1, id: 0 },
      { start: :c1, finish: :c2, id: 1 },
      { start: :c2, finish: :start, id: 2, action: 'x = x + 1' }
    ]
    max = 100000
    @graph.config[:loop_max] = max
    @graph.config[:visit_max] = max
    assert_search_cycle nodes, edges, status: :timeout

    assert_equal @graph.cycles.count, 1
    cycle = @graph.cycles.first
    assert_equal cycle[:start], :start
    assert_equal cycle[:nodes].count, 3
    assert_equal cycle[:nodes].to_set, %i[start c1 c2].to_set
    assert_equal cycle[:edges].count, 3
    assert_equal cycle[:edges].to_set, [0, 1, 2].to_set
    assert cycle[:loops] > 1
    assert cycle[:loops] < max
    assert_empty cycle[:path]
  end

  test 'valid dynamic cycle' do
    nodes = %i[start c1 c2 c3]
    edges = [
      { start: :start, finish: :c1, id: 0 },
      { start: :c1, finish: :c2, id: 1 },
      { start: :c2, finish: :c3, id: 2 },
      { start: :c3, finish: :c1, id: 3, condition: 'x < 5', action: 'x = x + 1' }
    ]

    @graph.config[:loop_max] = 10
    assert_search_cycle nodes, edges

    assert_equal @graph.cycles.count, 1
    cycle = @graph.cycles.first
    assert_equal cycle[:start], :c1
    assert_equal cycle[:nodes].count, 3
    assert_equal cycle[:nodes].to_set, %i[c1 c2 c3].to_set
    assert_equal cycle[:loops], 5
    assert_equal cycle[:edges].count, 3
    assert_equal cycle[:edges].to_set, [1, 2, 3].to_set
    assert_equal cycle[:path].count, 1
    path = cycle[:path]
    assert_equal path[0], node: :start, edge: 0
  end

  test 'valid long cycle' do
    nodes = %i[start i1 i2 i3 c1 c2 c3 c4 c5 c6]
    edges = [
      { start: :start, finish: :i1, id: 0 },
      { start: :i1, finish: :i2, id: 1 },
      { start: :i2, finish: :i3, id: 2 },
      { start: :i3, finish: :c1, id: 3 },
      { start: :c1, finish: :c2, id: 4 },
      { start: :c2, finish: :c3, id: 5 },
      { start: :c3, finish: :c4, id: 6 },
      { start: :c4, finish: :c5, id: 7 },
      { start: :c5, finish: :c6, id: 8 },
      { start: :c6, finish: :c1, id: 9, action: 'x = x + 1' }
    ]

    @graph.config[:loop_max] = 10
    assert_search_cycle nodes, edges

    assert_equal @graph.cycles.count, 1
    cycle = @graph.cycles.first
    assert_equal cycle[:start], :c1
    assert_equal cycle[:nodes].count, 6
    assert_equal cycle[:nodes].to_set, %i[c1 c2 c3 c4 c5 c6].to_set
    assert_equal cycle[:loops], 10
    assert_equal cycle[:edges].count, 6
    assert_equal cycle[:edges].to_set, [4, 5, 6, 7, 8, 9].to_set
    assert_equal cycle[:path].count, 4
    path = cycle[:path]
    assert_equal path[0], node: :start, edge: 0
    assert_equal path[1], node: :i1, edge: 1
    assert_equal path[2], node: :i2, edge: 2
    assert_equal path[3], node: :i3, edge: 3
  end

  test 'valid double cycle' do
    nodes = %i[start c1 c2 c3]
    edges = [
      { start: :start, finish: :c1, id: 0 },
      { start: :c1, finish: :c2, id: 1 },
      { start: :c1, finish: :c3, id: 2 },
      { start: :c3, finish: :start, id: 3, action: 'x = x + 1' },
      { start: :c2, finish: :start, id: 4, action: 'y = y + 1' }
    ]

    @graph.config[:loop_max] = 10
    assert_search_cycle nodes, edges, state: { x: 0, y: 0 }

    assert_equal @graph.cycles.count, 2
    cycle = @graph.cycles[0]
    assert_equal cycle[:start], :start
    assert_equal cycle[:nodes].count, 3
    assert_equal cycle[:nodes].to_set, %i[c1 c2 start].to_set
    assert_equal cycle[:loops], 10
    assert_equal cycle[:edges].count, 3
    assert_equal cycle[:edges].to_set, [0, 1, 4].to_set
    assert_empty cycle[:path]

    cycle = @graph.cycles[1]
    assert_equal cycle[:start], :start
    assert_equal cycle[:nodes].count, 3
    assert_equal cycle[:nodes].to_set, %i[c1 c3 start].to_set
    assert_equal cycle[:loops], 10
    assert_equal cycle[:edges].count, 3
    assert_equal cycle[:edges].to_set, [0, 2, 3].to_set
    assert_empty cycle[:path]
  end
end
# rubocop:enable Metrics/ClassLength
