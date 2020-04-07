# frozen_string_literal: true

class Node < ApplicationRecord
  belongs_to :graph
  has_many :output_edges,
    foreign_key: :start_id,
    class_name: 'Edge',
    dependent: :nullify,
    inverse_of: :start
  has_many :input_edges,
    foreign_key: :finish_id,
    class_name: 'Edge',
    dependent: :nullify,
    inverse_of: :finish

  enum kind: { start: 0, intermediate: 1, finish: 2 }

  after_create_commit { GraphBroadcastJob.perform_later graph, 'node_create', as_json }
  after_update_commit { GraphBroadcastJob.perform_later graph, 'node_update', as_json }
  after_destroy { GraphBroadcastJob.perform_later graph, 'node_destroy' }
end
