class ChangeTypeOfColumnsInSpot < ActiveRecord::Migration
  def change
    change_column :spots, :x_pos, :string
    change_column :spots, :y_pos, :string
  end
end
