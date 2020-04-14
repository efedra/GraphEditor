# frozen_string_literal: true

class Edge < ApplicationRecord
  belongs_to :start, class_name: 'Node'
  belongs_to :finish, class_name: 'Node'

  validates :start, :finish, presence: true

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
end
