class Event < ActiveRecord::Base
  has_many :pictures
  has_many :event_tags
  has_many :event_attendees
  has_many :users
  belongs_to :user

  geocoded_by :address
  after_validation :geocode
end
