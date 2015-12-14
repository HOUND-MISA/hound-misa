class ChangeApprovedDataTypeToBool < ActiveRecord::Migration
  def change
     change_column :events, :approved, :boolean
  end
end
