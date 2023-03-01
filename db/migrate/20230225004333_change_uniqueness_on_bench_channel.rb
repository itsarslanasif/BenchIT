class ChangeUniquenessOnBenchChannel < ActiveRecord::Migration[7.0]
  def change
    remove_index :bench_channels, :name
    add_index :bench_channels, [:name, :workspace_id], unique: true
  end
end
