# frozen_string_literal: true

class TestJob
  include Sidekiq::Job

  def perform(asd)
    puts asd
  end
end
