class CreateInvitable < ActiveRecord::Migration[7.0]
  def change
    create_table :invitables, id: :string do |t|
      t.string :token, null: false
      t.text :reason
      t.string :email, null: false
      t.integer :invitation_type, default: 0, null: false
      t.integer :status, default: 0, null: false
      t.boolean :has_account, default: false
      t.references :workspace, null: false, foreign_key: true, type: :string, index: true
      t.references :profile, null: false, foreign_key: true, type: :string, index: true
      t.references :acceptor, null: true, foreign_key: { to_table: :profiles }, type: :string, index: true
      t.timestamps
    end

    add_index :invitables, :token, unique: true
    add_index :invitables, [:workspace_id, :email], unique: true, name: 'index_invitables_on_workspace_id_and_email'
  end
end
