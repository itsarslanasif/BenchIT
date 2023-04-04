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
    ActiveRecord::Base.connection.execute(ActiveRecord::Base.sanitize_sql("CREATE DATABASE #{name}"))
    ActiveRecord::Base.connection.execute('BEGIN')
  end

  def establish_connection_to_workspace_db(name)
    workspace, user, profile = current_values

    ActiveRecord::Base.establish_connection(
      adapter: 'postgresql',
      encoding: 'unicode',
      pool: ENV.fetch('RAILS_MAX_THREADS', 5),
      username: ENV.fetch('POSTGRES_USERNAME', 'postgres'),
      password: ENV.fetch('POSTGRES_PASSWORD', '1234'),
      host: ENV.fetch('POSTGRES_HOST', 'localhost'),
      database: name
    )

    set_current_values(workspace, user, profile)
  end

  def switch_database
    return if current_database.eql?('benchit_dev')

    workspace, user, profile = current_values
    ActiveRecord::Base.establish_connection(:development)
    set_current_values(workspace, user, profile)
  end

  def generate_data(user, profile, workspace)
    ActiveRecord::Base.transaction do
      new_user = user.dup
      new_user.id = user.id
      new_user.save!
      new_workspace = workspace.dup
      new_workspace.id = workspace.id
      new_workspace.save!
      new_profile = profile.dup
      new_profile.id = profile.id
      new_profile.save!
      set_current_values(new_workspace, new_user, new_profile)
      new_channel = BenchChannel.create!(name: 'general', description: 'general')
      BenchConversation.create!(conversationable: new_channel)
      new_channel.channel_participants.create!(permission: true, profile_id: profile.id, role: :channel_manager)
    end
  end

  def set_current_values(workspace, user, profile)
    Current.workspace = workspace
    Current.user = user
    Current.profile = profile
    @current_user = user
  end

  def current_values
    [Current.workspace, Current.user, Current.profile]
  end

  def current_database
    ActiveRecord::Base.connection.execute('SELECT current_database()').getvalue(0, 0)
  end
end
