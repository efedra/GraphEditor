# frozen_string_literal: true

class Api::GraphsController < Api::BaseController
  def index
    render json: Graph.all, status: :ok
  end

  def show
    render json: Graph.find(params[:id]), status: :ok
  end

  def create
    atom(current_user, graph_params: graph_params)
  end

  def update
    atom(current_user, graph_id: params[:id], graph_params: graph_params)
  end

  def destroy
    atom(current_user, graph_id: params[:id])
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def graph_params
    params.require(:graph).permit(:name, :state)
  end
end
