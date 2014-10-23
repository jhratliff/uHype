class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :school
  has_many :comment_likes
  has_many :comment_unlikes
  has_many :comment_flags
end
