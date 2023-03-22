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
    current_db = ActiveRecord::Base.connection.execute('SELECT current_database()').getvalue(0, 0).eql?('benchit_dev')
    ActiveRecord::Base.establish_connection(:development) unless current_db
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
      Current.workspace = new_workspace
      Current.profile = new_profile
      new_channel = BenchChannel.create!(name: 'general', description: 'general')
      BenchConversation.create!(conversationable_type: 'BenchChannel', conversationable_id: new_channel.id)
      new_channel.channel_participants.create!(permission: true, profile_id: profile.id, role: :channel_manager)
    end
  end
end
