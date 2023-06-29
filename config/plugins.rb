# frozen_string_literal: true

class App < Roda
  plugin :default_headers,
         'Content-Type' => 'application/json; charset=utf-8',
         # 'Strict-Transport-Security'=>'max-age=16070400;', # Uncomment if only allowing https:// access
         'X-Frame-Options' => 'deny',
         'X-Content-Type-Options' => 'nosniff',
         'X-XSS-Protection' => '1; mode=block'

  plugin :sessions,
         key: 'session',
         cookie_options: { secure: ENVIRONMENT == :production },
         secret: ENV['SECRET_KEY']

  plugin :json_parser
  plugin :all_verbs
  plugin :hash_branches
  plugin :r

  plugin :common_logger, LOGGER unless ENVIRONMENT == :test

  plugin :delegate
  request_delegate :params

  plugin :not_found do
    '{"status":"not_found"}'
  end

  plugin :error_handler do |e|
    LOGGER.fatal e.class
    LOGGER.fatal e.message
    LOGGER.fatal e.backtrace.join("\n")
  end

  plugin :public if ENVIRONMENT != :production

  def self.freeze
    Sequel::Model.freeze_descendents
    DB.freeze
    super
  end

  def render_response(class_name, params)
    class_name.new.call(params).value_or do |error|
      case error
      in :unauthorized
        response.status = 403
        '{"status":"unauthorized"}'
      in :not_found
        response.status = 404
        '{"status":"not_found"}'
      in { validation_errors: errors }
        response.status = 422
        {
          status: 'validation_error',
          validation_errors: errors
        }.to_json
      in { error_message: error }
        response.status = 400
        {
          status: 'error',
          error_message: error
        }.to_json
      end
    end
  end
end
