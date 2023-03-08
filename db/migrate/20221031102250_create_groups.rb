class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups, id: :string, &:timestamps
  end
end
