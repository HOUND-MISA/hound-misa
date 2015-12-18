class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.date :start_date
      t.time :start_time
      t.text :address
      t.string :status
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
