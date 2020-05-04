# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  delegate :t, to: :class

  class << self
    def t(key, opts = {})
      I18n.t(locale_key(key), opts)
    end

    def locale_key(key)
      return key if key.first != '.'
      "activerecord#{key}"
    end

    def default(key, opts = {})
      t(".defaults.models.#{name.underscore}.#{key}", opts)
    end
  end

  def error(key, opts = {})
    t(".errors.models.#{self.class.name.underscore}.#{key}", opts)
  end

  def api_error(key, opts: {}, column: :base, **kwargs)
    if column == :base
      errors[:base] << { type: key, message: error(key, opts), **kwargs }
    else
      errors.add(column, type: key, message: error("#{column}.#{key}", opts), **kwargs)
    end
  end
end
