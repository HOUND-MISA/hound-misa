class Tag < ActiveRecord::Base
  has_many :event_tags
  has_many :user_tags
end
