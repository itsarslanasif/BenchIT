class AddForeignKeyToBenchChannel < ActiveRecord::Migration[7.0]
  def change
    add_reference :bench_channels, :workspace, null: false, foreign_key: true
  end
end
