namespace :db do
  desc 'Reset the database and seed the database'
  task db_reset: :environment do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
  end

  desc 'Drop all databases'
  task drop_all: :environment do
    Workspace.all.each do |workspace|
      db_name = workspace.company_name.downcase
      ActiveRecord::Base.connection.drop_database(db_name)
      puts "Dropped database '#{db_name}'"
    end
    Rake::Task['db:drop'].invoke
  end

  desc 'Migrate all databases'
  task migrate_all: :environment do
    Rake::Task['db:migrate'].invoke
    Workspace.all.each do |workspace|
      db_name = workspace.company_name.downcase

      ActiveRecord::Base.establish_connection(
        adapter: 'postgresql',
        encoding: 'unicode',
        pool: ENV.fetch('RAILS_MAX_THREADS', 5),
        username: ENV.fetch('POSTGRES_USERNAME', 'postgres'),
        password: ENV.fetch('POSTGRES_PASSWORD', '1234'),
        host: ENV.fetch('POSTGRES_HOST', 'localhost'),
        database: db_name
      )

      puts "Migrating database '#{db_name}'"
      ActiveRecord::MigrationContext.new('db/migrate/', ActiveRecord::SchemaMigration).migrate
      ActiveRecord::Base.clear_active_connections!
    end
  end
end
