class Event < ActiveRecord::Base
  has_many :pictures
  has_many :event_tags, dependent: :destroy
  has_many :event_attendees, dependent: :destroy
  belongs_to :user

  geocoded_by :address
  after_validation :geocode

  accepts_nested_attributes_for :event_tags, allow_destroy: :true, reject_if: :all_blank
  
  validates :name, :presence => true
  validates :address, :presence => true
  validates :start_date, :presence => true
end
