# frozen_string_literal: true

class Api::EdgesController < ApplicationController
  before_action :set_edge, only: %i[show update destroy]

  def index
    @edges = Edge.all
    render json: @edges
  end

  def show
    render json: @edge
  end

  def create
    @edge = Edge.new(edge_params)

    if @edge.save
      render json: @edge
    else
      render json: @edge.errors, status: :unprocessable_entity
    end
  end

  def update
    if @edge.update(edge_params)
      render :show, status: :ok, location: @edge
    else
      render json: @edge.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @edge.destroy
    head :no_content
  end

  private

  def set_edge
    @edge = Edge.find(params[:id])
  end

  def edge_params
    params.require(:edge).permit(:text, :weight, :start_id, :finish_id)
  end
end
