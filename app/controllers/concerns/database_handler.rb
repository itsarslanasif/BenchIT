module DatabaseHandler
  extend ActiveSupport::Concern

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
    ActiveRecord::Base.establish_connection(:development)
  end
end
