# frozen_string_literal: true

require 'spec_helper'
require 'devise'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'capybara/rails'

REQUIRED_DIRS = %w[
  support
  features/shared_examples
  models/shared_examples
]

REQUIRED_DIRS.each do |path|
  Dir[Rails.root.join("spec/#{path}/**/*.rb")].each { |f| require f }
end

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include TransactionalCapybara::AjaxHelpers
  config.use_transactional_fixtures = true
  # https://relishapp.com/rspec/rspec-rails/docs
  # Warden.test_mode!
  # config.after { Warden.test_reset! }
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.extend ControllerMacros, type: :controller
  # config.include Devise::Test::ControllerHelpers, type: :view
  # config.include Warden::Test::Helpers
  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.include DeviseRequestSpecHelpers, type: :feature
  config.include FormHelpers, type: :feature
  config.include Features::SessionHelpers, type: :feature
  config.include Capybara::Webkit::RspecMatchers, type: :feature
  config.include InjectSession, type: :feature
  config.include WaitForAjax, type: :feature
  config.include RedirectBack
  config.include Selectors
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
