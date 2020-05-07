# frozen_string_literal: true

class HomeController < ApplicationController
  layout false
  def index; end
  def editor; end
  def player; end

  def new_graph
    render json: Graph.find_by_name('Programming Languages')
  end
end
