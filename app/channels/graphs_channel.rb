# frozen_string_literal: true

class GraphsChannel < ApplicationCable::Channel
  def subscribed
    stream_from current_graph
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def current_graph
    @current_graph ||= current_user.graphs.find(params[:id])
  end
end
