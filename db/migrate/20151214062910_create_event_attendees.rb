class CreateEventAttendees < ActiveRecord::Migration
  def change
    create_table :event_attendees do |t|

      t.timestamps null: false
    end
  end
end
