class Api::GamesController < ApplicationController
  def index
    render json: games.all.to_json
  end
end