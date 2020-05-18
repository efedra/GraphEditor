# frozen_string_literal: true

class Edge < ApplicationRecord
  belongs_to :start, class_name: 'Node'
  belongs_to :finish, class_name: 'Node'

  validates :start, :finish, presence: true
  validate :condition_valid?, :action_valid?, :nodes_belongs_to_same_graph?

  after_create_commit { GraphBroadcastJob.perform_later graph, 'edge_create', as_json }
  after_update_commit do
    GraphBroadcastJob.perform_later(graph, 'edge_update', as_json) if saved_changes?
  end
  after_destroy { GraphBroadcastJob.perform_later graph, 'edge_destroy' }

  def self.simple(**kwargs)
    new(text: default(:text), weight: 1, **kwargs)
  end

  def as_json(options = {})
    super({ only: %i[id start_id finish_id text weight] }.merge(options))
  end

  def nodes_belongs_to_same_graph?
    return if start.graph_id == finish.graph_id
    api_error(:nodes_belong_to_different_graphs,
      start: { id: start.id, graph_id: start.graph_id },
      finish: { id: finish.id, graph_id: finish.graph_id })
    throw :abort
  end

  def graph
    (start || finish).graph
  end

  def action_valid?
    return if action.blank?
    result = QuestEngine::ActionParser.new.valid_action?(graph.state.keys, action)
    return if result
    api_error(:invalid,
      column: :action,
      action: action)
  end

  def condition_valid?
    return if condition.blank?
    result = QuestEngine::ConditionParser.new.valid_condition?(graph.state.keys, condition)
    return if result
    api_error(:invalid,
      column: :condition,
      condition: condition)
  end
end
