class EventAttendee < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  belongs_to :event, dependent: :destroy
end
