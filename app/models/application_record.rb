# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def t(key, opts = {})
    I18n.t(locale_key(key), opts)
  end

  def locale_key(key)
    return key if key.first != '.'
    "activerecord#{key}"
  end

  def error(key, opts = {})
    t(".errors.models.#{self.class.name.underscore}.#{key}", opts)
  end
end
