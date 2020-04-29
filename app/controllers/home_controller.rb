# frozen_string_literal: true

class HomeController < ApplicationController
  layout false
  def index; end
  def editor; end
  def player; end

  def new_graph
    render json: Graph.random_graph
  end
end
