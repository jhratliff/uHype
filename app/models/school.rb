class School < ActiveRecord::Base
  mount_uploader :logo, LogoUploader

end
