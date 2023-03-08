class CreateInvitables < ActiveRecord::Migration[7.0]
  def change
    create_table :invitables, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :token
      t.string :user_id
      t.string :workspace_id
      t.string :user_email
      t.string :token_type
      t.datetime :invitation_sent_at
      t.string :invitation_sent_by

      t.timestamps
    end
    add_index :invitables, :token
    add_index :invitables, :user_id
    add_index :invitables, :workspace_id
  end
end
