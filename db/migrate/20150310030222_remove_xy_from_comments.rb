class RemoveXyFromComments < ActiveRecord::Migration
  def change
    remove_column :comments, :x_pos
    remove_column :comments, :y_pos
  end
end
