# frozen_string_literal: true

class GraphsController < ApplicationController
  # i think this is a bad idea
  layout false
  before_action :authenticate_user!

  def show
    graph
    gon.global.graph_id = graph.id
  end

  def graph
    @graph ||= current_user.graphs.find(params[:id])
  end
end
