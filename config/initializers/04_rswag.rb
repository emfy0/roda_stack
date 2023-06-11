# frozen_string_literal: true

require_relative '../../vendor/rswag-api/lib/rswag/api'
require_relative '../../vendor/rswag-ui/lib/rswag/ui'
require_relative '../../vendor/rswag-api/lib/rswag/api/middleware'
require_relative '../../vendor/rswag-ui/lib/rswag/ui/middleware'

Rswag::Api.configure do |c|
  c.swagger_root = "#{ROOT_PATH}/docs"
end

Rswag::Ui.configure do |c|
  c.swagger_endpoint '/api-docs/v1/swagger.yaml', 'API V1 Docs'
end

class RodaRswag < Roda
  use Rswag::Api::Middleware, Rswag::Api.config
  use Rswag::Ui::Middleware, Rswag::Ui.config
end
