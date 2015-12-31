class Ad < ActiveRecord::Base
  has_attached_file :photo, styles: { large: "600x600>", medium: "300x300>", thumb: "100x100>"}
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
  validates :name, :presence => true
  validates :photo, :presence => true

  def to_s
    self.name
  end
end
