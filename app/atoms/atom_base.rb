# frozen_string_literal: true

class AtomBase < BaseService
  attr_reader :params

  def initialize(**params)
    @params = params
  end

  private

  def perform
    atom_perform
  rescue ActiveRecord::RecordNotFound => err
    @result = I18n.t('services.not_found_error', id: err.id, model: err.model)
    @status = :not_found_error
  rescue ActiveRecord::RecordInvalid => err
    if err.record.present?
      @result = err.record.errors
    else
      @result = err.to_s
    end
    @status = :validation_error
  rescue ActiveRecord::StatementInvalid => err
    if Rails.env.production?
      @result = I18n.t('services.db_error')
    else
      @result = err.to_s
    end
    @status = :db_error
  end

  def atom_perform
    raise NotImplementedError
  end
end
