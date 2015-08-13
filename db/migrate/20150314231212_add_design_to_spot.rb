class AddDesignToSpot < ActiveRecord::Migration
  def change
    add_reference :spots, :design, index: true
    add_foreign_key :spots, :designs
  end
end
