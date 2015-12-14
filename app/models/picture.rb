class Picture < ActiveRecord::Base
  belongs_to :event, dependent: :destroy
end
