class AddCreatedAt < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :created_at, :timestamp
  end
end
