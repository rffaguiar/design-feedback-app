class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :comment
      t.integer :x_pos
      t.integer :y_pos

      t.timestamps null: false
    end
  end
end
