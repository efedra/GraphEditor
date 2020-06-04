# frozen_string_literal: true

class DynamicGraph
  attr_reader :status, :cycles, :nodes, :edges
  attr_reader :tree, :config, :terminal_nodes
  attr_reader :condition_processor
  delegate :allowed_condition?, to: :condition_processor

  class UndefinedVertex < StandardError
    attr_reader :vertex
    def initialize(vertex, message = nil)
      @vertex = vertex
      message ||= "Unecpected vertex '#{vertex}', firstly add vertex '#{vertex}'"
      super(message)
    end
  end

  class IdTaken < StandardError
    attr_reader :id
    def initialize(id, message = nil)
      @id = id
      message ||= "Edge id '#{id}' already taken"
      super(message)
    end
  end

  class SearchTimeout < StandardError; end

  def initialize(**args)
    @vertices = Set.new
    @all_edges = {}
    @output_edges = {}
    @config = {
      search_timeout: 5, # seconds
      loop_max: 10 # break path when cycle looped more than loop_max
    }
    @config.merge!(args)

    @action_processor = QuestEngine::ActionParser.new
    @condition_processor = QuestEngine::ConditionParser.new
  end

  def add_vertex(vertex)
    @vertices << vertex
  end

  def add_edge(start, finish, id, **options)
    raise UndefinedVertex, start unless @vertices.include?(start)
    raise UndefinedVertex, finish unless @vertices.include?(finish)
    raise IdTaken, id if @all_edges[id].present?

    @output_edges[start] ||= []
    @output_edges[start] << id
    @all_edges[id] = { start: start, finish: finish, id: id, **options }
  end

  def bfs_search_tree_from(start, state = {})
    @tree = {}
    @cycles = []
    @map_cycles = {}
    @terminal_nodes = []
    @nodes = Set.new
    @edges = Set.new
    @queue = Queue.new
    @status = :processing
    @start_time = Time.zone.now
    node = calc_node(start, state)
    @queue << start_path(node)
    @nodes << start
    # TODO: prepare queue in parallel
    until @queue.empty?
      break if timeout? @start_time
      path = @queue.pop
      next add_terminal_node(path[:node]) if @output_edges[path[:node][:vertex]].blank?
      any_node_visited = false
      @output_edges[path[:node][:vertex]].each do |edge_id|
        edge = @all_edges[edge_id]
        next unless can_visit? path[:node], edge
        any_node_visited = true
        state = do_action(path[:node], edge)
        next_node = calc_node(edge[:finish], state)
        mark next_node, edge
        next if visited? next_node
        visit path, next_node, edge
        check path, next_node, edge
      end
      add_terminal_node(path[:node]) unless any_node_visited
    end
    @finish_time = Time.zone.now
    if @queue.empty?
      @status = :success
    elsif @start_time.since(config[:search_timeout]) < @finish_time
      @status = :timeout
    end
  end

  def paths
    terminal_nodes.map { |node| build_path(node) }
  end

  private

  def build_path(node)
    result = []
    # cycle[:nodes] << current_path[:node][:vertex]
    # cycle[:edges] << current_path[:edge]
    # current_path = @tree[current_path[:node]]
    # current_path = @tree[current_path[:node]]
    current_path = tree[node]
    until current_path.nil?
      result.unshift(current_path[:edge])
      current_path = @tree[current_path[:node]]
    end
    result
  end

  def add_terminal_node(node)
    @terminal_nodes << node
  end

  def start_path(node)
    { node: node, info: { edges: {} } }
  end

  def calc_path(info, node, edge)
    new_info = info.deep_dup
    new_info[:edges][edge] ||= 0
    new_info[:edges][edge] += 1
    { node: node, info: new_info }
  end

  def calc_node(vertex, state)
    { vertex: vertex, state: state }
  end

  def check(path, node, edge)
    if cycle? path, edge
      add_cycle path, node, edge
    elsif loop? path, edge
      update_cycle path, node, edge
    end
  end

  def mark(node, edge)
    @nodes << node[:vertex]
    @edges << edge[:id]
  end

  def visit(path, node, edge)
    @tree[node] = { node: path[:node], edge: edge[:id] }
    @queue << calc_path(path[:info], node, edge[:id]) unless finish? path, node, edge
  end

  def finish?(path, _node, edge)
    path[:info][:edges][edge[:id]] == @config[:loop_max]
  end

  def cycle?(path, edge)
    prev_edge = @tree.dig(path[:node], :edge)
    path[:info][:edges][prev_edge] == 1 && (prev_edge.blank? || path[:info][:edges][edge[:id]] == 1)
  end

  def loop?(path, edge)
    prev_edge = @tree.dig(path[:node], :edge)
    prev_edge.present? && path[:info][:edges][prev_edge] == path[:info][:edges][edge[:id]]
  end

  def timeout?(start_time)
    start_time.since(config[:search_timeout]) < Time.zone.now
  end

  def visited?(node)
    @tree[node].present?
  end

  def can_visit?(node, edge)
    edge[:condition].blank? || allowed_condition?(node[:state], edge[:condition])
  end

  def do_action(node, edge)
    return node[:state] if edge[:action].blank?
    dup_state = node[:state].deep_dup
    @action_processor.perform(dup_state, edge[:action])
    dup_state
  end

  def add_cycle(path, node, edge)
    cycle = calc_cycle path, node, edge
    @cycles << cycle
    @map_cycles[cycle[:edges]] = cycle
  end

  def update_cycle(path, node, edge)
    cycle = calc_cycle path, node, edge
    @map_cycles[cycle[:edges]][:loops] += 1
  end

  def calc_cycle(_path, node, edge)
    current_path = @tree[node]
    cycle = {
      start: current_path[:node][:vertex],
      loops: 1,
      nodes: [],
      edges: [],
      path: []
    }
    current_edge = @tree.dig(current_path[:node], :edge)
    while current_edge != edge[:id]
      cycle[:nodes] << current_path[:node][:vertex]
      cycle[:edges] << current_path[:edge]

      current_path = @tree[current_path[:node]]
      current_edge = @tree[current_path[:node]][:edge]
    end
    cycle[:nodes] << current_path[:node][:vertex]
    cycle[:edges] << current_path[:edge]
    current_path = @tree[current_path[:node]]
    current_path = @tree[current_path[:node]]
    until current_path.nil?
      cycle[:path].unshift(node: current_path[:node][:vertex], edge: current_path[:edge])
      current_path = @tree[current_path[:node]]
    end
    cycle
  end
end
