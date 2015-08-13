class CreateDesigns < ActiveRecord::Migration
  def change
    create_table :designs do |t|
      t.string :title
      t.string :subtitle
      t.string :link
      t.string :image_path
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :designs, :users
  end
end
