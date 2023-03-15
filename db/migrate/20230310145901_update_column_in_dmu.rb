class UpdateColumnInDmu < ActiveRecord::Migration[7.0]
  def up
    change_column :direct_message_users, :receiver_id, :string
  end

  def down
    change_column :direct_message_users, :receiver_id, :bigint, using: 'receiver_id::integer'
  end
end
