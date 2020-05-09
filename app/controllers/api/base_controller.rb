# frozen_string_literal: true

class Api::BaseController < ApplicationController
  include Pundit
  after_action :verify_authorized
  before_action :authenticate_user!

  rescue_from(ActionController::ParameterMissing) do |err|
    error = {
      type: :parameter_missing,
      message: I18n.t('errors.parameter_missing_error', param: err.param),
      required_params: err.param
    }
    handle_error error
  end

  rescue_from(ActiveRecord::RecordNotFound) do |err|
    error = {
      type: :record_not_found,
      message: I18n.t('errors.not_found_error', id: err.id, model: err.model),
      record_id: err.id,
      model: err.model
    }
    handle_error error, :not_found
  end

  rescue_from(ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved, ActiveRecord::RecordNotDestroyed) do |err|
    if err.record.present?
      error = {
        type: :validation_failed,
        messages: err.record.errors
      }
      status = :unprocessable_entity
    else
      error = {
        type: :database_error,
        message: I18n.t('errors.db_error', errors: err.to_s)
      }
      status = :internal_server_error
    end
    handle_error error, status
  end

  rescue_from Pundit::NotAuthorizedError do |err|
    message = err.class.method_defined?(:reason) ? I18n.t("pundit.errors.#{err.reason}") : err.message
    error = {
      type: :not_authorized,
      message: message,
      query: err.query,
      model: err.record.class.to_s
    }
    handle_error error, :forbidden
  end

  def handle_error(message = '', status = :bad_request)
    render json: { error: message }, status: status
  end

  def authenticate_user!
    return if current_user
    error = {
      type: :unauthorized,
      message: I18n.t('devise.failure.unauthenticated')
    }
    handle_error error, :unauthorized
  end
end
