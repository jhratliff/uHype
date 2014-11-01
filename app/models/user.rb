class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  acts_as_token_authenticatable
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?


  belongs_to :school
  has_many :follow_schools
  has_many :followed_schools, :through => :follow_schools, :source => :school

  has_many :comments
  has_many :flagged_comments, :through => :comment_flags, :source => :comment
  has_many :liked_comments, :through => :comment_likes, :source => :comment
  has_many :unliked_comments, :through => :comment_unlikes, :source => :comment

  has_many :snapshots
  has_many :sent_messages, :foreign_key => 'user_id', :class_name => 'Message'
  has_many :received_messages, :through => :sent_messages, :source => 'messaged'

  # set up the friends relationships (people I follow)
  has_many :followings                                              # the following records I created
  has_many :friends, :through => :followings, :source => 'followed' # the user records of people I follow from the records I created

  # set up the followers relationships (people who follow me)
  has_many :followeds, :class_name => 'Following', :foreign_key => 'followed_id' # the following records where I'm being followed, created by others
  has_many :followers, :through => :followeds, :source => :user # the user records associated with the following records where I'm being followed

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
