# frozen_string_literal: true

class BaseTransaction
  include Dry::Transaction(container: Application::CONTAINER)

  def unwrap(input) = input.deep_symbolize_keys!

  def typecast(input)
    self.class::REQUEST_SCHEMA
      .call(input)
      .to_dry_result
      .or { |e| Failure(validation_errors: e) }
  end
end
