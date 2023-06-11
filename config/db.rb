# frozen_string_literal: true

require 'sequel/core'

# Delete APP_DATABASE_URL from the environment, so it isn't accidently
# passed to subprocesses.  APP_DATABASE_URL may contain passwords.

db_url =
  case ENVIRONMENT
  in :development | :production
    'DATABASE_URL'
  in :test
    'TEST_DATABASE_URL'
  end

DB = Sequel.connect(ENV.delete(db_url))

# Load Sequel Database/Global extensions here
# DB.extension :date_arithmetic
DB.extension :pg_auto_parameterize if DB.adapter_scheme == :postgres && Sequel::Postgres::USES_PG
