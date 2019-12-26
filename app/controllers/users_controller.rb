class Api::UsersController < ApplicationController
  def index
    render json: users.all
  end
end