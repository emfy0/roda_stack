# frozen_string_literal: true

def parse_schema
  require 'uri'

  db_url =
    case ENV['RACK_ENV'].to_sym
    in :development | :production
      'DATABASE_URL'
    in :test
      'TEST_DATABASE_URL'
    end

  db_url = ENV[db_url]

  uri = URI.parse(db_url)

  {
    database: ((uri.path || '').split('/')[1]).to_s,
    adapter: uri.scheme,
    user: uri.user,
    password: uri.password,
    host: uri.host,
    port: uri.port
  }
end

namespace :db do
  desc 'Annotate Sequel models'
  task :annotate do
    require_relative '../config/application'
    require 'sequel/annotate'

    Sequel::Annotate.annotate(Dir['app/models/**/*.rb'], position: :before)
  end

  task :g_migration, [:name] do |_t, args|
    time = Time.now.utc.strftime('%Y%m%d%H%M%S')
    filename = File.join('db/migrate', "#{time}_#{args.name}.rb")
    File.write(filename, <<~RUBY)
      # frozen_string_literal: true

      Sequel.migration do
        change do
        end
      end
    RUBY

    puts "Created migration '#{filename}'"
  end

  task :create do
    require 'sequel/core'

    params = parse_schema
    database = params.delete(:database)

    Sequel.connect(params) do |db|
      db.execute "CREATE DATABASE #{database}"
    end

    puts "*** database #{database} created **"
  end

  task :drop do
    require 'sequel/core'

    params = parse_schema
    database = params.delete(:database)

    Sequel.connect(params) do |db|
      db.execute "DROP DATABASE #{database}"
    end

    puts "*** database #{database} dropped **"
  end

  task migrate: ['migrate:up']
  task rollback: ['migrate:down']

  namespace :migrate do
    task :connect do
      require_relative '../config/application'
      Sequel.extension :migration
    end

    desc 'Perform migration reset (full erase and migration up).'
    task reset: [:connect] do
      Sequel::Migrator.run(DB, 'db/migrate', target: 0)
      Sequel::Migrator.run(DB, 'db/migrate')
      puts '*** db:migrate:reset executed ***'
    end

    desc 'Perform migration up/down to VERSION.'
    task to: [:connect] do
      version = ENV['VERSION'].to_i
      if version.zero?
        puts 'VERSION must be larger than 0. Use rake db:migrate:down to erase all data.'
        exit false
      end

      Sequel::Migrator.run(DB, 'db/migrate', target: version)
      puts "*** db:migrate:to VERSION=[#{version}] executed ***"
    end

    desc 'Perform migration up to latest migration available.'
    task up: [:connect] do
      Sequel::Migrator.run(DB, 'db/migrate')
      puts '*** db:migrate:up executed ***'
    end

    desc 'Perform migration down.'
    task down: [:connect] do
      version =
        DB
        .fetch('SELECT "filename" FROM "schema_migrations" ORDER BY "filename"')
        .to_a[-2][:filename]
        .split('_')[0]

      Sequel::Migrator.run(DB, 'db/migrate', target: version.to_i)
      puts '*** db:migrate:down executed ***'
    end
  end
end
