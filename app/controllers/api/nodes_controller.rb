# frozen_string_literal: true

class Api::NodesController < ApplicationController
  before_action :set_node, only: %i[show update destroy]

  def index
    @nodes = Node.all
    render json: @nodes
  end

  def show
    render json: @node
  end

  def create
    @node = Node.new(node_params)

    if @node.save
      render json: @node
    else
      render json: @node.errors, status: :unprocessable_entity
    end
  end

  def update
    if @node.update(node_params)
      render :show, status: :ok, location: @node
    else
      render json: @node.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @node.destroy
    head :no_content
  end

  private

  def set_node
    @node = Node.find!(params[:id])
  end

  def node_params
    params.require(:node).permit(:name, :graph_id, text: nil)
  end
end
