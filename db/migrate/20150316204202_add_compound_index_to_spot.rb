class AddCompoundIndexToSpot < ActiveRecord::Migration
  def change
    add_index :spots, [:design_id, :x_pos, :y_pos], unique: true
  end
end
