# frozen_string_literal: true

class Graph::Base < AtomBase
  attr_reader :user

  def initialize(user, **params)
    super(params)
    @user = user
  end

  private

  def graphs
    user.graphs
  end

  def graph
    graphs.find(params[:graph_id])
  end

  def graph_params
    params[:graph_params]
  end
end
