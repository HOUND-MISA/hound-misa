class User < ActiveRecord::Base
  has_many :events, dependent: :destroy
  has_many :event_attendees, dependent: :destroy
  has_attached_file :avatar, styles: { large: "600x600>", medium: "300x300>", thumb: "100x100>"}
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  belongs_to :event

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :description, :length => {:maximum => 40}

  def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.first_name = auth.info.first_name
        user.last_name = auth.info.last_name
        user.password = Devise.friendly_token[0,20]
      end
  end

  def to_s
    self.first_name + " " + self.last_name
  end

end
