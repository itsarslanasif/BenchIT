class DropInvitable < ActiveRecord::Migration[7.0]
  def change
    drop_table :invitables
  end
end
