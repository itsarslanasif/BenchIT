class ChangeIdOfBenchChannel < ActiveRecord::Migration[7.0]
  def up
    remove_foreign_key :channel_participants, :bench_channels

    change_column :bench_channels, :id, :string

    change_column :channel_participants, :bench_channel_id, :string

    add_foreign_key :channel_participants, :bench_channels, column: :bench_channel_id, primary_key: :id
  end

  def down
    remove_foreign_key :channel_participants, :bench_channels

    change_column :bench_channels, :id, :bigint, using: 'id::bigint'

    change_column :channel_participants, :bench_channel_id, :bigint, using: 'bench_channel_id::bigint'

    add_foreign_key :channel_participants, :bench_channels, column: :bench_channel_id, primary_key: :id
  end
end
