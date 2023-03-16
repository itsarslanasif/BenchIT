class AddIndexOnProfileInDownload < ActiveRecord::Migration[7.0]
  def up
    add_index :downloads, :profile_id
  end

  def down
    remove_index :downloads, :profile_id
  end
end
