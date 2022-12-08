class AddForignKeyToReaction < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :reactions, :users
  end
end
