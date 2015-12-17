class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.text :address
      t.boolean :approved
      t.string :website
      t.float :latitude
      t.float :longitude
      t.text :address_one
      t.string :city
      t.string :province
      t.integer :attendee_count

      t.timestamps null: false
    end
  end
end
