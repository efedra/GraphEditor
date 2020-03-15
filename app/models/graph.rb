# frozen_string_literal: true

class Graph < ApplicationRecord
  has_many :nodes, dependent: :nullify
  belongs_to :user

  validates :name, :state, presence: true

  after_update_commit { GraphBroadcastJob.perform_later self, 'graph_update', self.as_json }
  after_destroy { GraphBroadcastJob.perform_later self, 'graph_destroy' }

  def edges
    Edge.where(start_id: nodes.select(:id))
      .or(Edge.where(finish_id: nodes.select(:id)))
  end
end
