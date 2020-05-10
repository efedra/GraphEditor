# frozen_string_literal: true

require 'test_helper'

class DynamicGraph::BaseTest < ActiveSupport::TestCase
  setup do
    @graph = DynamicGraph.new
    @graph.config[:search_timeout] = 1
  end

  test 'invalid add edge to undefined node' do
    nodes = %i[start finish]
    nodes.each { |n| @graph.add_vertex(n) }
    assert_raises DynamicGraph::UndefinedVertex do
      @graph.add_edge(:start, :undefined, :id)
    end
  end

  test 'invalid add edge with taken id' do
    nodes = %i[start finish]
    nodes.each { |n| @graph.add_vertex(n) }
    @graph.add_edge(:start, :finish, :id)
    assert_raises DynamicGraph::IdTaken do
      @graph.add_edge(:start, :finish, :id)
    end
  end

  def assert_bfs_search(nodes, edges, finish_nodes: nil, finish_edges: nil, state: {})
    finish_nodes ||= nodes
    finish_edges ||= edges

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

    assert_equal @graph.status, :success
    assert_equal finish_nodes.to_set, @graph.nodes.to_set
    assert_equal finish_edges.map { |e| e[:id] }.to_set, @graph.edges.to_set
  end

  test 'valid search simple graph' do
    nodes = %i[start finish]
    edges = [{ start: :start, finish: :finish }]
    assert_bfs_search nodes, edges
  end

  test 'valid search long graph' do
    nodes = %i[start intermedate finish]
    edges = [
      { start: :start, finish: :finish },
      { start: :start, finish: :intermedate },
      { start: :intermedate, finish: :finish }
    ]
    assert_bfs_search nodes, edges
  end

  test 'valid search complex graph' do
    nodes = %i[start i1 i2 i3 f]
    edges = [
      { start: :start, finish: :f },
      { start: :start, finish: :i1 },
      { start: :start, finish: :i2 },
      { start: :i1, finish: :i2 },
      { start: :i1, finish: :f },
      { start: :i1, finish: :i3 },
      { start: :i2, finish: :f },
      { start: :i2, finish: :i3, id: 1 },
      { start: :i2, finish: :i3, id: 2 },
      { start: :i3, finish: :f }
    ]
    assert_bfs_search nodes, edges
  end

  test 'valid search two components' do
    finish_nodes = %i[start i1 f1]
    other_nodes = %i[s2 i2 f2]
    finish_edges = [
      { start: :start, finish: :f1 },
      { start: :start, finish: :i1 },
      { start: :i1, finish: :f1 }
    ]
    other_edges = [
      { start: :s2, finish: :f2 },
      { start: :s2, finish: :i2 },
      { start: :i2, finish: :f2 }
    ]
    all_nodes = finish_nodes + other_nodes
    all_edges = finish_edges + other_edges

    assert_bfs_search all_nodes, all_edges,
      finish_nodes: finish_nodes,
      finish_edges: finish_edges
  end

  test 'valid search two components by condition' do
    finish_nodes = %i[start i1 f1]
    other_nodes = %i[s2 i2 f2]
    finish_edges = [
      { start: :start, finish: :f1 },
      { start: :start, finish: :i1 },
      { start: :i1, finish: :f1 }
    ]
    other_edges = [
      { start: :i1, finish: :s2, condition: 'x == 1' },
      { start: :s2, finish: :f2 },
      { start: :s2, finish: :i2 },
      { start: :i2, finish: :f2 }
    ]
    all_nodes = finish_nodes + other_nodes
    all_edges = finish_edges + other_edges

    assert_bfs_search all_nodes, all_edges,
      finish_nodes: finish_nodes,
      finish_edges: finish_edges,
      state: { x: 0 }
  end

  test 'valid search one components by condition' do
    nodes = %i[start i1 f1 s2 i2 f2]
    edges = [
      { start: :start, finish: :f1 },
      { start: :start, finish: :i1 },
      { start: :i1, finish: :f1 },
      { start: :i1, finish: :s2, condition: 'x == 0' },
      { start: :s2, finish: :f2 },
      { start: :s2, finish: :i2 },
      { start: :i2, finish: :f2 }
    ]

    assert_bfs_search nodes, edges,
      state: { x: 0 }
  end

  test 'valid search action and condition' do
    finish_nodes = %i[start i1 i2 i3 f1]
    other_nodes = [:f2]
    finish_edges = [
      { start: :start, finish: :i1, id: 0, action: 'x = x + 1' },
      { start: :i1, finish: :i2, id: 1, condition: 'x == 1' },
      { start: :i1, finish: :i3, id: 2, condition: 'x == 1', action: 'x = x + 1' },
      { start: :i3, finish: :f1, id: 3, condition: 'x == 2' }
    ]
    other_edges = [
      { start: :i2, finish: :f2, id: 4, condition: 'x == 2' }
    ]
    all_nodes = finish_nodes + other_nodes
    all_edges = finish_edges + other_edges

    assert_bfs_search all_nodes, all_edges,
      finish_nodes: finish_nodes,
      finish_edges: finish_edges,
      state: { x: 0 }
  end

  test 'valid search one components by multiedges' do
    nodes = %i[start i1 f1 s2 i2 f2]
    finish_edges = [
      { start: :start, finish: :f1 },
      { start: :start, finish: :i1 },
      { start: :i1, finish: :f1 },
      { start: :i1, finish: :s2, condition: 'x == 0' },
      { start: :s2, finish: :f2 },
      { start: :s2, finish: :i2 },
      { start: :i2, finish: :f2 }
    ]
    other_edges = [
      { start: :i1, finish: :s2, condition: 'x == 1' }
    ]
    all_edges = finish_edges + other_edges

    assert_bfs_search nodes, all_edges,
      finish_edges: finish_edges,
      state: { x: 0 }
  end
end
