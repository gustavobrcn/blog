class AddCreatedAtForFriends < ActiveRecord::Migration[6.0]
  def change
    add_column :friends, :created_at, :timestamp
  end
end
