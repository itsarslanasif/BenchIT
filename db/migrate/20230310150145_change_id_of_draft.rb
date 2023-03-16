class ChangeIdOfDraft < ActiveRecord::Migration[7.0]
  def up
    change_column :draft_messages, :id, :string
  end

  def down
    change_column :draft_messages, :id, :bigint, using: 'id::bigint'
  end
end
