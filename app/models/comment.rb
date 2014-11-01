class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :school

  has_many :comment_likes
  has_many :comment_likers, :through => :comment_likes, :source => :user


  has_many :comment_unlikes
  has_many :comment_unlikers, :through => :comment_unlikes, :source => :user

  has_many :comment_flags
  has_many :comment_flaggers, :through => :comment_flags, :source => :user


end
