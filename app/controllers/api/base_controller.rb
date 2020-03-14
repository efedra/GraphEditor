# frozen_string_literal: true

class Api::BaseController < ApplicationController
  before_action :authenticate_user!

  # TODO: Feel free to remove, just an examples
  before_action :log_intro
  after_action :log_outro

  rescue_from(ActionController::ParameterMissing) do |err|
    handle_error I18n.t('errors.parameter_missing_error', param: err.param)
  end

  rescue_from(ActiveRecord::RecordNotFound) do |err|
    handle_error I18n.t('errors.not_found_error', id: err.id, model: err.model), :not_found
  end

  rescue_from(ActiveRecord::RecordInvalid) do |err|
    if err.record.present?
      error = err.record.errors
    else
      error = I18n.t('errors.db_error', errors: err.to_s)
    end
    handle_error error, :unprocessable_entity
  end

  def log_intro
    Rails.logger.info('Processing API Request')
  end

  def log_outro
    Rails.logger.info("Responded with: #{response.body}")
  end

  def handle_error(message = '', status = :bad_request)
    render json: { error: message }, status: status
  end

  def authenticate_user!
    return if current_user
    render json: I18n.t('devise.failure.unauthenticated'), status: :unauthorized
  end
end
