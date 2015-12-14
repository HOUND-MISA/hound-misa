class CreateEventTags < ActiveRecord::Migration
  def change
    create_table :event_tags do |t|

      t.timestamps null: false
    end
  end
end
