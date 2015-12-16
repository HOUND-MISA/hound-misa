class Event < ActiveRecord::Base
  has_many :pictures
  has_many :event_tags, dependent: :destroy
  has_many :event_attendees, dependent: :destroy
  belongs_to :user

  geocoded_by :address
  after_validation :geocode
  before_validation :load_defaults
  before_save :set_address

  accepts_nested_attributes_for :event_tags, allow_destroy: :true, reject_if: :all_blank
  
  validates :name, :presence => true
  validates :city, :presence => true
  validates :start_date, :presence => true

  def load_defaults
    if self.new_record?
      self.attendee_count = 0
    end
  end

  def set_address
    self.address = self.unit + " " + self.building + " " + self.street + " " + self.district + " " + self.city + " City " + self.province
  end
end
