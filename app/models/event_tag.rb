class EventTag < ActiveRecord::Base
  belongs_to :tag, dependent: :destroy
  belongs_to :event, dependent: :destroy
end
