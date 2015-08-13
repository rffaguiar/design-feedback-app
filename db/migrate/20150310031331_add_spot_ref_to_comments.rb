class AddSpotRefToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :spot, index: true
    add_foreign_key :comments, :spots
  end
end
