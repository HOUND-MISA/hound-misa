class Tag < ActiveRecord::Base
  has_many :event_tags, dependent: :destroy
  has_many :user_tags, dependent: :destroy
  has_attached_file :photo, styles: { large: "600x600>", medium: "300x300>", thumb: "100x100>"}
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
  validates :name, :presence => true

  #accepts_nested_attributes_for :event_tags, allow_destroy: :true, reject_if: :all_blank

  def to_s
    self.name
  end
end
