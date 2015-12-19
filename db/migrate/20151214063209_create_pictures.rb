class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :description
      t.boolean :primary_picture,  default: false

      t.timestamps null: false
    end
  end
end
