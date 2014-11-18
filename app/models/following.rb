class Following < ActiveRecord::Base

  belongs_to :user
  belongs_to :followed, :class_name => 'User'

  # member 'status' can have the following values:
  # null - this record should be removed
  # "requested" - the initiating party has requested the follow (recipient is a private user only)
  # "approved" - the follow relationship has been approved (automatic for non-private users)
  # "declined" - the recipient has declined this follow (recipient is a private user only)

end