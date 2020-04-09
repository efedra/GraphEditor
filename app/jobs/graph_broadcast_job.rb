class GraphBroadcastJob < ApplicationJob
  queue_as :default

  def perform(graph, type, data = nil)
    ActionCable.server.broadcast graph, type: type, data: data
  end
end
