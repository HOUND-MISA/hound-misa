class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
