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

  after_create_commit { GraphBroadcastJob.perform_later graph, 'node_create', self.as_json }
  after_update_commit { GraphBroadcastJob.perform_later graph, 'node_update', self.as_json }
  after_destroy { GraphBroadcastJob.perform_later graph, 'node_destroy' }
end
