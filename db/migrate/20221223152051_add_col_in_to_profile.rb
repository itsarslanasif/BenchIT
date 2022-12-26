class AddColInToProfile < ActiveRecord::Migration[7.0]
  def change
    change_table :profiles, bulk: true do |t|
      t.column :display_name, :string, null: false, default: '', limit: 80
      t.column :title, :string, null: false, default: ''
      t.column :pronounce_name, :string, null: false, default: ''
      t.column :text_status, :string, null: false, default: '', limit: 100
      t.column :emoji_status, :string, null: false, default: ''
      t.column :phone, :string, null: false, default: ''
      t.column :skype, :string, default: ''
      t.column :time_zone, :string, null: false, default: 'UTC'
    end
  end
end
