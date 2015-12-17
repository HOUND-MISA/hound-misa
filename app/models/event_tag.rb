class EventTag < ActiveRecord::Base
  belongs_to :tag
  belongs_to :event

  validates :tag_id, :uniqueness => {:scope => :event_id}
end
