class RemoveExtraColumnsFromInvitable < ActiveRecord::Migration[7.0]
  def change
    remove_column :invitables, :user_email
    remove_column :invitables, :invitation_sent_at
    remove_column :invitables, :invitation_sent_by
  end
end
