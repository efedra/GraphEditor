# frozen_string_literal: true

class UserBroadcastJob < ApplicationJob
  queue_as :default

  def perform(user, type, data = nil)
    UsersChannel.broadcast_to user, type: type, data: data
  end
end
