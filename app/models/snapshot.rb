class Snapshot < ActiveRecord::Base
  mount_uploader :photo, PhotoUploader

  belongs_to :user
  has_many :snapshot_flags
  has_many :snapshot_likes
  has_many :snapshot_unlikes
end
