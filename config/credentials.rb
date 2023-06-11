# frozen_string_literal: true

require 'encrypted_credentials/coder'
require 'yaml'

# key_hex =
#   File.read(
#     if ENVIRONMENT == :production
#       "#{__dir__}/credentials/production.key"
#     else
#       "#{__dir__}/credentials/development.key"
#     end
#   )

# data =
#   File.read(
#     if ENVIRONMENT == :production
#       "#{__dir__}/credentials/production.yml.enc"
#     else
#       "#{__dir__}/credentials/development.yml.enc"
#     end
#   )

# CREDENTIALS = (
#   YAML.load(
#     EncryptedCredentials::Coder.decrypt(data, key_hex), symbolize_names: true
#   ) || {}
# ).freeze

nil
