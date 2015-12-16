class Tag < ActiveRecord::Base
  has_many :event_tags, dependent: :destroy
  has_many :user_tags, dependent: :destroy
  validates :name, :presence => true

  accepts_nested_attributes_for :event_tags, allow_destroy: :true, reject_if: :all_blank

  def to_s
    self.name
  end
end
