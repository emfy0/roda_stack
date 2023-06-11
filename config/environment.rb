# frozen_string_literal: true

require 'logger'

ROOT_PATH = File.expand_path('..', __dir__).freeze
ENVIRONMENT = ENV['RACK_ENV'].to_sym.freeze
LOGGER =
  Logger.new(
    if ENV['DOCKER_LOGS']
      io = IO.new(IO.sysopen('/proc/1/fd/1', 'w'), 'w')
      io.sync = true
      io
    else
      $stdout
    end
  )

LOGGER.level = Logger::FATAL if ENVIRONMENT == :test

Bundler.require(:default, ENVIRONMENT)

include Dry::Monads[:result]

require 'active_support/all'
require_relative 'credentials'
require_relative 'db'
require_relative 'models'

require 'zeitwerk'

loader = Zeitwerk::Loader.new
Dir["#{ROOT_PATH}/app/**"].sort.each { |path| loader.push_dir path }
loader.ignore("#{ROOT_PATH}/app/controllers")
loader.setup

Dir["#{__dir__}/initializers/*.rb"].sort.each { |path| require path }

loader.eager_load_dir("#{ROOT_PATH}/app/channels")
loader.eager_load if ENVIRONMENT == :production
