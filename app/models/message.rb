class Message < ActiveRecord::Base
  mount_uploader :media, MediaUploader

  belongs_to :user
  belongs_to :recipient, :class_name => 'User'
end
