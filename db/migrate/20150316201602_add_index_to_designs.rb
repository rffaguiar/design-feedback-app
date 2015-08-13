class AddIndexToDesigns < ActiveRecord::Migration
  def change
    add_index :designs, :link, unique: true
  end
end
