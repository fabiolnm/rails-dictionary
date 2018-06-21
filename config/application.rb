require_relative 'boot'

require 'rails/all'
require 'slim/smart'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsDictionary
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.generators do |g|
      # don't generate empty files when using scaffold/resource generators:
      # - app/assets/javascripts
      # - app/assets/stylesheets
      # - app/helper files
      g.assets false
      g.helper false

      g.template_engine = :slim
      g.test_framework :minitest, spec: true
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
