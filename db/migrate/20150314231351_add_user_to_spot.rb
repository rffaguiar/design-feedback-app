class AddUserToSpot < ActiveRecord::Migration
  def change
    add_reference :spots, :user, index: true
    add_foreign_key :spots, :users
  end
end
