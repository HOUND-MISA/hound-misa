class AddColumnsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :unit, :string
    add_column :events, :building, :string
    add_column :events, :street, :string
    add_column :events, :district, :string
    add_column :events, :city, :string
    add_column :events, :province, :string
  end
end
