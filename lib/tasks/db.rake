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
    end
    Rake::Task['db:drop'].invoke
  end
end
