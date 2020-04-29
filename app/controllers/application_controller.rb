# frozen_string_literal: true

class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token, unless: :production?

  def production?
    Rails.env.production?
  end

  delegate :t, to: :class

  class << self
    def t(key, opts = {})
      I18n.t(locale_key(key), opts)
    end

    def locale_key(key)
      return key if key.first != '.'
      "controllers.#{controller_path}.#{key}"
    end
  end
end
