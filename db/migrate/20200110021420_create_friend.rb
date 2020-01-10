class CreateFriend < ActiveRecord::Migration[6.0]
  def change
    create_table :friends do |t|
      t.integer :user_id
      t.string :friend 
      t.boolean :friended, default: true
    end
  end
end
