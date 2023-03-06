class AddProfileIdToDraftMessages < ActiveRecord::Migration[7.0]
  def change
    add_reference :draft_messages, :profile, null: false, foreign_key: true, type: :uuid, index: true
  end
end
