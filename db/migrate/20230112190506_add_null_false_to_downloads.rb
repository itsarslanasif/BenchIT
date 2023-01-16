class AddNullFalseToDownloads < ActiveRecord::Migration[7.0]
  def change
    change_column_null :downloads, :profile_id, false
    change_column_null :downloads, :file_name, false
    change_column_null :downloads, :file_link, false
    change_column_null :downloads, :file_download_link, false
    change_column_null :downloads, :file_type, false
    add_foreign_key :downloads, :profiles, column: :profile_id
  end
end
