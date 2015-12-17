class Event < ActiveRecord::Base
  has_many :pictures
  has_many :event_tags, dependent: :destroy
  has_many :event_attendees, dependent: :destroy
  belongs_to :user

  geocoded_by :address
  after_validation :geocode
  before_validation :load_defaults
  before_validation :set_address

  accepts_nested_attributes_for :event_tags, allow_destroy: :true, reject_if: :all_blank
  
  validates :name, :presence => true
  validates :city, :presence => true
  validates :start_date, :presence => true

  self.per_page = 9

  STATUSES = ["Pending","Approved","Rejected"]
  validates :status, :presence => true, :inclusion => {:in => STATUSES}

  def load_defaults
    if self.new_record?
      self.attendee_count = 0
      self.status = "Pending"
    end
  end
  
  def set_address
    if self.address_one == ""
      self.address = self.city + " City " + self.province
    else
      self.address = self.address_one + " " + self.city + " City " + self.province
    end
  end

  def approve!
    if self.status == "Approved"
      raise "ERROR: Event already approved"
    elsif self.status == "Rejected"
      raise "ERROR: Cannot approve rejected event"
    else
      self.update!(status: "Approved")
    end
  end

  def reject!
    if self.status == "Rejected"
      raise "ERROR: Event already rejected"
    elsif self.status == "Approved"
      raise "ERROR: Cannot reject approved event"
    else
      self.update!(status: "Rejected")
    end
  end
end
