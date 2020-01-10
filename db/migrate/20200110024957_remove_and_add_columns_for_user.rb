class RemoveAndAddColumnsForUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :created_at, :timestamp
    remove_column :users, :date_created, :string
  end
end
