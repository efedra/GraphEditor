# frozen_string_literal: true

class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token, unless: :production?

  def production?
    Rails.env.production?
  end
end
