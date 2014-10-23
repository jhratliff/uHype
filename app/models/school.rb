class School < ActiveRecord::Base
  mount_uploader :logo, LogoUploader

  has_many :users
  has_many :follow_schools
  has_many :followers, :through => :follow_schools, :source => :user

end
