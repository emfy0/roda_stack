require_relative 'ui/configuration'

module Rswag
  module Ui
    def self.configure
      yield(config)
    end

    def self.config
      @config ||= Configuration.new
    end
  end
end