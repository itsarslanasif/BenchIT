class RenameColumnBenchitUrl < ActiveRecord::Migration[7.0]
  def change
    rename_column :workspaces, :benchIT_URL, :bench_it_url
  end
end
