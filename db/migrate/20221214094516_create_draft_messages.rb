class CreateDraftMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :draft_messages do |t|

      t.timestamps
    end
  end
end
