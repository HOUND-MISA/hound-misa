class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.text :address
      t.integer :approved
      t.string :website
      t.float :lat
      t.float :lon

      t.timestamps null: false
    end
  end
end
