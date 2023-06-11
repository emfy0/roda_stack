# frozen_string_literal: true

class NotificationsChannel < BaseChannel
  identifier :notifications

  def subscribed
    stream_from 'notifications'
  end
end
