class CreateDownloads < ActiveRecord::Migration[7.0]
  def change
    create_table :downloads do |t|
      t.integer :profile_id
      t.string :file_name
      t.string :file_link
      t.string :file_download_link
      t.string :file_type
      t.timestamps
    end
  end
end
