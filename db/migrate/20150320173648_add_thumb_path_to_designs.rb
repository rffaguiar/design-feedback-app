class AddThumbPathToDesigns < ActiveRecord::Migration
  def change
    add_column :designs, :image_thumb_path, :string
  end
end
