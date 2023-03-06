class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups, id: :uuid, &:timestamps
  end
end
