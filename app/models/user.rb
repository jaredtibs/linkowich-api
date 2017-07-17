class User < ApplicationRecord
  devise :database_authenticatable, :trackable, :recoverable
  mount_uploader :avatar, AvatarUploader

  def image_data=(data)
    # decode data and create stream on them
    io = CarrierStringIO.new(Base64.decode64(data))
    self.avatar = io
  end

end
