class ChangeColumnName < ActiveRecord::Migration
  def change
  	rename_column :events, :lat, :latitude
  	rename_column :events, :lon, :longitude
  end
end
