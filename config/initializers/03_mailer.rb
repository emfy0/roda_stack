# frozen_string_literal: true

require 'mail'

Mail.defaults do
  case ENVIRONMENT
  in :production
  # delivery_method :smtp, {
  #   address: 'smtp.mail.ru',
  #   port: 465,
  #   domain: 'mail.ru',
  #   authentication: 'plain',
  #   user_name: CREDENTIALS.dig(:email, :from),
  #   password: CREDENTIALS.dig(:email, :password),
  #   tls: true
  # }
  in :development
    delivery_method :smtp, {
      address: 'mailhog',
      port: 1025,
      authentication: 'none'
    }
  in :test
    delivery_method :test
  end
end
