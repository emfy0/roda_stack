# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require_relative '../config/boot'

require_relative 'spec_helper'
require_relative 'test_helper'

require 'dry/container/stub'
Application::CONTAINER.enable_stubs!

require 'swagalicious'
require 'database_cleaner-sequel'

DatabaseCleaner.allow_remote_database_url = true

FactoryBot.find_definitions

FactoryBot.define do
  to_create(&:save)
end

module RSpecMixin
  include Rack::Test::Methods
  def app
    App
  end
end

RSpec.configure do |c|
  c.include RSpecMixin

  c.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  c.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  c.include FactoryBot::Syntax::Methods

  c.swagger_root = "#{ROOT_PATH}/docs"
  c.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      produces: 'application/json'
    }
  }
end
