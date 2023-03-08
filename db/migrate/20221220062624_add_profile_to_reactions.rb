class AddProfileToReactions < ActiveRecord::Migration[7.0]
  def change
    add_reference :reactions, :profile, null: false, foreign_key: true, type: :string, index: true
  end
end
