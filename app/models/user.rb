class User < ApplicationRecord
  devise :database_authenticatable, :trackable, :recoverable
  mount_uploader :avatar, AvatarUploader

end
