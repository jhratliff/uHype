class Snapshot < ActiveRecord::Base
  mount_uploader :photo, PhotoUploader
  mount_uploader :video, PhotoUploader

  belongs_to :user

  has_many :snapshot_likes
  has_many :snapshot_likers, :through => :snapshot_likes, :source => :user


  has_many :snapshot_unlikes
  has_many :snapshot_unlikers, :through => :snapshot_unlikes, :source => :user

  has_many :snapshot_flags
  has_many :snapshot_flaggers, :through => :snapshot_flags, :source => :user

  has_many :snapshot_comments


end
