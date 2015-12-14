class AddReferentialIntegrity < ActiveRecord::Migration
  def change
    add_foreign_key :events, :users
    add_foreign_key :pictures, :events
    add_foreign_key :event_attendees, :users
    add_foreign_key :event_attendees, :events
    add_foreign_key :event_tags, :events
    add_foreign_key :event_tags, :tags
    add_foreign_key :user_tags, :users
    add_foreign_key :user_tags, :tags
  end
end
