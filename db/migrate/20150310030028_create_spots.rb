class CreateSpots < ActiveRecord::Migration
  def change
    create_table :spots do |t|
      t.text :x_pos
      t.text :y_pos

      t.timestamps null: false
    end
  end
end
