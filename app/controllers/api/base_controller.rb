# frozen_string_literal: true

class Api::BaseController < ApplicationController
  ATOM_STATUS = {
    success: :ok,
    successfully_created: :created,
    successfully_destoyed: :no_content,
    not_found_error: :not_found,
    validation_error: :bad_request,
    db_error: :unprocessable_entity
  }.freeze

  rescue_from(ActionController::ParameterMissing) do |err|
    render json: I18n.t('services.parameter_missing_error', param: err.param), status: :bad_request
  end

  private

  def atom(*args)
    service = "#{controller_name.classify}::#{action_name.camelize}".constantize.call(*args)
    render json: service.result, status: ATOM_STATUS[service.status]
  end
end
