# frozen_string_literal: true

class Node < ApplicationRecord
  include LiberalEnum

  belongs_to :graph
  has_many :output_edges,
    foreign_key: :start_id,
    class_name: 'Edge',
    dependent: :destroy,
    inverse_of: :start
  has_many :input_edges,
    foreign_key: :finish_id,
    class_name: 'Edge',
    dependent: :destroy,
    inverse_of: :finish

  enum kind: { start: 0, intermediate: 1, finish: 2, bad: 3 }
  liberal_enum :kind

  validates :kind, presence: true, inclusion: { in: Node.kinds.keys }
  validates :html_x, :html_y, presence: true, numericality: { only_integer: true }
  before_create :already_has_start?
  before_update :changes_last_start?, :changes_last_finish?, :changes_multiple_starts?
  before_destroy :destroy_last_finish?, :destroy_last_start?, :destroy_any_finish_reachable?

  after_create_commit { GraphBroadcastJob.perform_later graph, 'node_create', as_json }
  after_update_commit { GraphBroadcastJob.perform_later graph, 'node_update', as_json }
  after_destroy { GraphBroadcastJob.perform_later graph, 'node_destroy' }

  def self.simple(**kwargs)
    new(html_x: 0, html_y: 0, name: default(:name), text: default(:text), **kwargs)
  end

  def already_has_start?
    return unless graph.nodes.start.count >= 1 && start?
    errors[:base] << error(:multiple_starts)
    throw :abort
  end

  def changes_last_start?
    return unless graph.nodes.start.count == 1 && !start? && kind_was == 'start'
    errors[:base] << error(:no_start)
    throw :abort
  end

  def changes_last_finish?
    return unless graph.nodes.finish.count == 1 && !finish? && kind_was == 'finish'
    errors[:base] << error(:no_finish)
    throw :abort
  end

  def changes_multiple_starts?
    return unless graph.nodes.start.count >= 1 && start? && kind_was != 'start'
    errors[:base] << error(:multiple_starts)
    throw :abort
  end

  def destroy_last_finish?
    return unless graph.nodes.finish.count <= 1 && finish?
    errors[:base] << error(:no_finish)
    throw :abort
  end

  def destroy_last_start?
    return unless graph.nodes.start.count <= 1 && start?
    errors[:base] << error(:no_start)
    throw :abort
  end

  def destroy_any_finish_reachable?
    # TODO
  end
end
