class School < ActiveRecord::Base
  mount_uploader :logo, LogoUploader

  has_many :users

  has_many :school_follows
  has_many :followers, :through => :school_follows

end
