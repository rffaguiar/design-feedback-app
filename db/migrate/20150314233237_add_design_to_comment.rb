class AddDesignToComment < ActiveRecord::Migration
  def change
    add_reference :comments, :design, index: true
    add_foreign_key :comments, :designs
  end
end
