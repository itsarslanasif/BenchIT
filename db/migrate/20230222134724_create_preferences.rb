class CreatePreferences < ActiveRecord::Migration[7.0]
  def change
    create_table :preferences, id: :uuid do |t|
      t.references :profile, null: false, foreign_key: true, type: :uuid
      t.json :notifications, null: false, default: '{"notify_me_about": 1, [], "my_keywords": [], "allow_notifications": "", "default_time_for_remider_notifications": "", "sound_and_appearance: [1],}'
      t.json :sidebar, null: false, default: '{"alway_show_in_sidebar":[1,2,5,6], "show": 1, "sort":{1,[1,4,5,6]} }'
      t.json :themes, null: false, default: '{"sync_with_os_settings": true, "colors":4,}'
      t.json :messages_and_media, null: false, default: '{"theme": 1, "names": 1, "additional_options": [1, 3], "emoji": { "default_skin_tone": 1, "additional_options": [2, 4],"one_click_emoji": 2 },"inline_media_and_links": [1, 2]}'
      t.json :language_and_region, null: false, default: '{"language": "English(US)", "timezone":"Islamabad,Karachi", "spell_check":true}'
      t.json :accessibility, null: false, default: '{"zoom": 4, "links": true, "animation": true, "message_format": 1, "direct_message_announcements":true, "huddles_announcements":[1, 2], "keyboard": 1}'
      t.json :mark_as_read, null: false, default: '{"when_i_view_a_channel": 1, "when_i_mark_everything_as_read": true}'
      t.json :audio_and_video, null: false, default: '{"microphone": {1, [1, 2]}, "speaker": 1, "when_joining_a_slackcall": [1], "when_joining_a_huddle": [1,4,5], "when_slack_is_in_the_background": true, "when_your_screen_saver_starts_or_computer_locks": [1, 2]}'
      t.json :connected_accounts, null: false, default: '{"links_and_content_from_other_apps": true}'
      t.json :privacy_and_visibility, null: false, default: '{"slack_connect_discoverability": 1, "contact_sharing": 1 }'
      t.json :advanced, null: false, default: '{"input_options": [], "when_writing_a_message": 1, "search_options": "", "download_action": {true,""}, "confirmations_and_warnings": [1, 2, 3, 4], "other_options": [1]}'
      t.timestamps
    end
  end
end
