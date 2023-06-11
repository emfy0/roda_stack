# frozen_string_literal: true

require_relative 'db'
require 'sequel/model'

Sequel::Model.plugin :auto_validations
Sequel::Model.plugin :require_valid_schema
Sequel::Model.plugin :subclasses

DB.loggers << LOGGER

class Sequel::Model
  private

  # def full_message(attribute, error_msg)
  #   "#{Array(attribute).join(I18n.t('errors.joiner'))} #{error_msg}"
  # end

  def default_validation_helpers_options(type)
    namespace = 'sequel_errors'

    case type
    when :exact_length
      { message: ->(exact) { I18n.t("#{namespace}.exact_length", exact:) } }
    when :format
      { message: -> { I18n.t("#{namespace}.format") } }
    when :includes
      { message: ->(set) { I18n.t("#{namespace}.includes", range: set.inspect) } }
    when :integer
      { message: -> { I18n.t("#{namespace}.integer") } }
    when :length_range
      { message: -> { I18n.t("#{namespace}.length_range") } }
    when :max_length
      { message: ->(max) { I18n.t("#{namespace}.max_length", max:) } }
    when :nil_message
      { message: -> { I18n.t("#{namespace}.nil_message") } }
    when :max_value
      { message: -> { I18n.t("#{namespace}.max_value") } }
    when :min_length
      { message: ->(_exact) { I18n.t("#{namespace}.min_length", min:) } }
    when :min_value
      { message: -> { I18n.t("#{namespace}.min_value") } }
    when :not_null
      { message: -> { I18n.t("#{namespace}.not_null") } }
    when :no_null_byte
      { message: -> { I18n.t("#{namespace}.no_null_byte") } }
    when :numeric
      { message: -> { I18n.t("#{namespace}.numeric") } }
    when :operator
      { message: ->(operator, rhs) { I18n.t("#{namespace}.operator", operator:, rhs:) } }
    when :type
      message = lambda do |klass|
        error_message =
          if klass.is_a?(Array)
            klass.join(' or ').downcase
          else
            klass.to_s.downcase
          end

        I18n.t("#{namespace}.type", error_message:)
      end

      { message: }
    when :presence
      { message: -> { I18n.t("#{namespace}.presence") } }
    when :unique
      { message: -> { I18n.t("#{namespace}.unique") } }
    else
      super
    end
  end
end
