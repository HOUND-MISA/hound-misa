class Tag < ActiveRecord::Base
  has_many :event_tags
  has_many :user_tags

  def to_s
    self.name
  end

  accepts_nested_attributes_for :event_tags
end
