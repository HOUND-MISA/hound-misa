class UserTag < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  belongs_to :tag, dependent: :destroy
end
