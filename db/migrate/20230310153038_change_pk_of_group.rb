class ChangePkOfGroup < ActiveRecord::Migration[7.0]
  def up
    change_column :groups, :id, :string
  end

  def down
    change_column :groups, :id, :bigint, using: 'id::bigint'
  end
end
