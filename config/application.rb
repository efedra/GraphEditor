# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

#=======| neo4j ruby gem thing |=======#
require 'active_graph/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GraphEditor
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # !!!
    # =======| neo4j ruby gem thing |=======
    config.generators { |g| g.orm :active_graph }
    # !!!

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
