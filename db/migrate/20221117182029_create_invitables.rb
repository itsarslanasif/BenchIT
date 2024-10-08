class CreateInvitables < ActiveRecord::Migration[7.0]
  def change
    create_table :invitables do |t|
      t.string :token
      t.integer :user_id
      t.integer :workspace_id
      t.string :user_email
      t.string :token_type
      t.datetime :invitation_sent_at
      t.string :invitation_sent_by

      t.timestamps
    end
    add_index :invitables, :token
  end
end
