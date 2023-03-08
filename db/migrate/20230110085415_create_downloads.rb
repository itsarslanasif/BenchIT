class CreateDownloads < ActiveRecord::Migration[7.0]
  def change
    create_table :downloads, id: :uuid do |t|
      t.string :profile_id
      t.string :file_name
      t.string :file_link
      t.string :file_download_link
      t.string :file_type
      t.timestamps
    end
    add_index :downloads, :profile_id
  end
end
