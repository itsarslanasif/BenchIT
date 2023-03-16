class ChangeRecordIdInActiveStorage < ActiveRecord::Migration[7.0]
  def up
    change_column :active_storage_attachments, :record_id, :string
  end

  def down
    change_column :active_storage_attachments, :record_id, :bigint, using: 'record_id::integer'
  end
end
