class UpdateDraftMessageContentType < ActiveRecord::Migration[7.0]
  def up
    change_column :draft_messages, :content, 'json USING content::json'
  end

  def down
    change_column :draft_messages, :content, :text
  end
end
