# frozen_string_literal: true

class Node < ApplicationRecord
  include LiberalEnum

  KIND_START = 0
  KIND_INTERMEDIATE = 1
  KIND_END = 2

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

  after_create_commit { GraphBroadcastJob.perform_later graph, 'node_create', as_json }
  after_update_commit { GraphBroadcastJob.perform_later graph, 'node_update', as_json }
  after_destroy { GraphBroadcastJob.perform_later graph, 'node_destroy' }

  def self.simple(**kwargs)
    new(html_x: 0, html_y: 0, name: default(:name), text: default(:text), **kwargs)
  end
end
