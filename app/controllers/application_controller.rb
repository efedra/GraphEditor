# frozen_string_literal: true

class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token, unless: :production?

  def production?
    ENV['RAILS_ENV'] == 'production'
  end

  def atom(*args)
    "#{controller_name.classify}::#{action_name.camelize}".constantize.call(*args)
  end
end
