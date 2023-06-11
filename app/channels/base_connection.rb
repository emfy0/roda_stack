# frozen_string_literal: true

class BaseConnection < LiteCable::Connection::Base
  def connect = $stdout.puts 'connected'
  def disconnect = $stdout.puts 'disconnected'
end
