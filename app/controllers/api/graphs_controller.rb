# frozen_string_literal: true

class Api::GraphsController < ApplicationController
  def index
    render json: Graph.all
  end

  def show
    render json: Graph.find(params[:id])
  end

  def create
    service = atom(graph_params: graph_params)

    if service.success?
      render json: service.result, status: :created
    else
      render json: service.error, status: :unprocessable_entity
    end
  end

  def update
    service = atom(graph_id: params[:id], graph_params: graph_params)

    if service.success?
      render json: service.result, status: :ok
    else
      render json: service.error, status: :unprocessable_entity
    end
  end

  def destroy
    atom(graph_id: params[:id])
    head :no_content
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def graph_params
    params.require(:graph).permit(:name, :state)
  end
end
