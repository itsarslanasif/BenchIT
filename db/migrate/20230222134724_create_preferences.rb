class CreatePreferences < ActiveRecord::Migration[7.0]
  def change
    create_table :preferences do |t|
      t.references :profile, null: false, foreign_key: true
      t.json :messages_and_media, null: false, default: '{"theme": 1, "names": 1, "additional_options": [1, 3], "emoji": { "default_skin_tone": 1, "additional_options": [2, 4],"one_click_emoji": 2 },"inline_media_and_links": [1, 2]}'
      t.timestamps
    end
  end
end
