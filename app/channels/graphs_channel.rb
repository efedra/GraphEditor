# frozen_string_literal: true

class GraphsChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_graph
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def current_graph
    @current_graph ||= NeoGraph.find_by(uuid: params[:graph_id])
  end
end
