# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'

require 'spec_helper'

require File.expand_path('../dummy/config/environment', __FILE__)

require 'rspec/rails'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean_with(:truncation)

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

RSpec.configure do |config|
  config.include TemporaryModelsHelpers, temporary_models: true

  config.around do |example|
    DatabaseCleaner.cleaning { example.run }
  end
end
