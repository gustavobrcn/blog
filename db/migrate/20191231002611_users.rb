class Users < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
    t.string :name
    t.string :email
    t.string :password
    t.integer :age
    t.date :birthday #adding birthday column
    t.string :posts
    end
  end
end
