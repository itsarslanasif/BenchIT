class ChangingThePkOfOtherTables < ActiveRecord::Migration[7.0]
  def up
    change_column :pins, :id, :string
    change_column :reactions, :id, :string
    change_column :saved_items, :id, :string
    change_column :preferences, :id, :string
    change_column :statuses, :id, :string
    change_column :invitables, :id, :string
    change_column :downloads, :id, :string
    change_column :direct_message_users, :id, :string
  end

  def down
    change_column :pins, :id, :bigint, using: 'id::bigint'
    change_column :reactions, :id, :bigint, using: 'id::bigint'
    change_column :saved_items, :id, :bigint, using: 'id::bigint'
    change_column :preferences, :id, :bigint, using: 'id::bigint'
    change_column :statuses, :id, :bigint, using: 'id::bigint'
    change_column :invitables, :id, :bigint, using: 'id::bigint'
    change_column :downloads, :id, :bigint, using: 'id::bigint'
    change_column :direct_message_users, :id, :bigint, using: 'id::bigint'
  end
end
