class AddApproveToEvent < ActiveRecord::Migration
  def change
    add_column :events, :approved, :bool
  end
end
