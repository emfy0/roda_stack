# frozen_string_literal: true

require_relative 'environment'

require_relative 'plugins'

Dir["#{ROOT_PATH}/app/controllers/**/*.rb"]
  .sort_by { |f| f.count('/') }
  .each { |path| require path }

require_relative 'routes'
