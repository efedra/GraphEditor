# frozen_string_literal: true

class BaseService
  attr_accessor :result
  attr_reader :status

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
    @result = nil
    @status = :success

    logger.info("Start.")
    perform

    self
  rescue StandardError => err
    @result = err
    @status = :unrecognized_error

    raise
  ensure
    logger.info("Finish with status:#{status}, result:#{result}.")
  end

  def success?
    !fail?
  end

  def fail?
    status.to_s.end_with? 'error'
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
