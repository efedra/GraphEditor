# frozen_string_literal: true

class UsersChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def current_user
    @current_user ||= User.find(params[:user_id])
  end
end
