class AddForeignKeys < ActiveRecord::Migration
  def change
    add_column :events, :user_id, :integer
    add_column :pictures, :event_id, :integer
    add_column :event_attendees, :user_id, :integer
    add_column :event_attendees, :event_id, :integer
    add_column :event_tags, :event_id, :integer
    add_column :event_tags, :tag_id, :integer
    add_column :user_tags, :user_id, :integer
    add_column :user_tags, :tag_id, :integer
  end
end
