module DatabaseHandler
  extend ActiveSupport::Concern

  def setup_database(user, profile, workspace, name)
    create_database(name)
    establish_connection_to_workspace_db(name)
    ActiveRecord::MigrationContext.new('db/migrate/', ActiveRecord::SchemaMigration).migrate
    generate_data(user, profile, workspace)
  end

  def create_database(name)
    ActiveRecord::Base.connection.execute('COMMIT')
    ActiveRecord::Base.connection.execute("CREATE DATABASE #{name}")
    ActiveRecord::Base.connection.execute('BEGIN')
  end

  def drop_database(name)
    ActiveRecord::Base.connection.execute('COMMIT')
    ActiveRecord::Base.connection.execute("DROP DATABASE #{name}")
    ActiveRecord::Base.connection.execute('BEGIN')
  end

  def establish_connection_to_workspace_db(name)
    ActiveRecord::Base.establish_connection(
      adapter: 'postgresql',
      encoding: 'unicode',
      pool: ENV.fetch('RAILS_MAX_THREADS', 5),
      username: ENV.fetch('POSTGRES_USERNAME', 'postgres'),
      password: ENV.fetch('POSTGRES_PASSWORD', '1234'),
      host: ENV.fetch('POSTGRES_HOST', 'localhost'),
      database: name
    )
  end

  def switch_database
    ActiveRecord::Base.establish_connection(:development) unless ActiveRecord::Base.connection.execute('SELECT current_database()').getvalue(0,
                                                                                                                                             0).eql?('benchit_dev')
  end

  def generate_data(user, profile, workspace)
    new_user = user.dup
    new_user.id = user.id
    new_user.save!
    new_workspace = workspace.dup
    new_workspace.id = workspace.id
    new_workspace.save!
    new_profile = profile.dup
    new_profile.id = profile.id
    new_profile.save!
  end
end
