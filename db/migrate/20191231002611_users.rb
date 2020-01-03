class Users < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name 
      t.string :email
      t.string :username
      t.string :password
      t.integer :age
      t.date :birthday 
      t.string :sex
      t.string :posts
      t.string :main
    end
  end
end
