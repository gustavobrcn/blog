class AddRemoveColumns < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :user_id, :integer
    remove_column :posts, :username, :date
  end
end
