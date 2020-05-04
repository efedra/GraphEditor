# frozen_string_literal: true

class GraphBroadcastJob < ApplicationJob
  queue_as :default

  def perform(graph, type, data = nil)
    GraphsChannel.broadcast_to graph, type: type, data: data
  end
end
