# frozen_string_literal: true

class BaseService
  attr_accessor :result, :error
  attr_reader :success

  class << self
    def call(*args)
      logger.tagged(name) do
        logger.info("Initializing with args: #{args}")
        service = new(*args)
        service.call
      end
    end

    def logger
      Rails.logger
    end
  end

  def call
    @success = true
    @result = nil
    @error = nil

    logger.info("Start.")
    perform
    logger.info("Finish with success:#{success}, result:#{result}, error:#{error}.")

    self
  rescue StandardError => err
    @error = err
    @success = false

    raise
  end

  def success?
    success
  end

  def fail?
    !success?
  end

  private

  def perform
    raise NotImplementedError
  end

  def logger
    self.class.logger
  end

  def t(key, opts = {})
    I18n.t(locale_key(key), opts)
  end

  def locale_key(key)
    "services.#{self.class.name.underscore.tr('/', '.')}.#{key}"
  end
end
