# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, I18n.t('pundit.errors.not_authorized') unless user
    @user   = user
    @record = record
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      raise Pundit::NotAuthorizedError, I18n.t('pundit.errors.not_authorized') unless user
      @user = user
      @scope = scope
    end
  end
end
