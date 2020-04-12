# frozen_string_literal: true

class Edge < ApplicationRecord
  belongs_to :start, class_name: 'Node'
  belongs_to :finish, class_name: 'Node'

  # errors
  validates :start, :finish, presence: true
  before_create :create_nodes_belongs_to_same_graph?
  before_update :changes_any_finish_reachable?
  before_destroy :destroy_any_finish_reachable?

  # warnings
  before_create :creation_increase_components?,
    :create_deadlock_state?,
    :create_terminal_not_finish_state?
  before_update :updation_increase_components?,
    :updation_makes_deadlock_state?,
    :updation_makes_terminal_not_finish_state?
  before_destroy :deletion_increase_components?,
    :deletion_makes_deadlock_state?,
    :deletion_makes_terminal_not_finish_state?

  after_create_commit { GraphBroadcastJob.perform_later graph, 'edge_create', as_json }
  after_update_commit { GraphBroadcastJob.perform_later graph, 'edge_update', as_json }
  after_destroy { GraphBroadcastJob.perform_later graph, 'edge_destroy' }

  def self.simple(**kwargs)
    new(text: default(:text), weight: 1, **kwargs)
  end

  def as_json(options = {})
    super({ only: %i[id start_id finish_id text weight] }.merge(options))
  end

  def graph
    (start || finish).graph
  end

  def create_nodes_belongs_to_same_graph?
    return if start.graph_id == finish.graph_id
    errors[:base] << error(:nodes_belong_to_different_graphs)
    throw :abort
  end

  def changes_any_finish_reachable?
    # TODO
  end

  def destroy_any_finish_reachable?
    # TODO
  end

  def creation_increase_components?
    # TODO
  end

  def create_deadlock_state?
    # TODO
  end

  def create_terminal_not_finish_state?
    # TODO
  end

  def updation_increase_components?
    # TODO
  end

  def updation_makes_deadlock_state?
    # TODO
  end

  def updation_makes_terminal_not_finish_state?
    # TODO
  end

  def deletion_increase_components?
    # TODO
  end

  def deletion_makes_deadlock_state?
    # TODO
  end

  def deletion_makes_terminal_not_finish_state?
    # TODO
  end
end
