class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  acts_as_token_authenticatable
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?


  belongs_to :school
  has_many :follow_schools
  has_many :followed_schools, :through => :follow_schools, :source => :school

  has_many :comments
  has_many :comment_flags
  has_many :flagged_comments, :through => :comment_flags, :source => :comment
  has_many :comment_likes
  has_many :liked_comments, :through => :comment_likes, :source => :comment
  has_many :comment_unlikes
  has_many :unliked_comments, :through => :comment_unlikes, :source => :comment

  has_many :snapshots
  has_many :snapshot_flags
  has_many :flagged_snapshots, :through => :snapshot_flags, :source => :snapshot
  has_many :snapshot_likes
  has_many :liked_snapshots, :through => :snapshot_likes, :source => :snapshot
  has_many :snapshot_unlikes
  has_many :unliked_snapshots, :through => :snapshot_unlikes, :source => :snapshot


  has_many :messages

  has_many :snapshot_comments

  # this would be all the messages I've sent
  has_many :sent_messages, :foreign_key => 'user_id', :class_name => 'Message'

  # this corresponds roughly to "people I've messaged" - not terribly useful at the moment
  # has_many :received_messages, :through => :sent_messages, :source => 'recipient'

  has_many :received_messages, :foreign_key => 'recipient_id', :class_name => 'Message'

  # set up the friends relationships (people I follow)
  has_many :followings # the following records I created
  has_many :friends, :through => :followings, :source => 'followed' # the user records of people I follow from the records I created

  # set up the followers relationships (people who follow me)
  has_many :followeds, :class_name => 'Following', :foreign_key => 'followed_id' # the following records where I'm being followed, created by others
  has_many :followers, :through => :followeds, :source => :user # the user records associated with the following records where I'm being followed

  def set_default_role
    self.role ||= :user
  end


  def clear_badge
    self.badge_count = 0
    self.save
    self.send_badge(0)
  end

  def increment_badge
    self.badge_count += 1
    self.save
    self.send_badge(self.badge_count)
  end

  def send_alert (payload)

    if !payload.nil? and payload.length > 0 and !self.endpoint_arn.nil? and self.endpoint_arn.length > 0
      trimmed_message = payload[0..200]
      client = Aws::SNS::Client.new(region: 'us-west-2')
      apns_payload = {"aps" => {"alert" => trimmed_message}}.to_json
      message = {"default" => "alert message", "APNS" => apns_payload}.to_json

      client.publish(message: message, target_arn: self.endpoint_arn, message_structure: 'json')
    end
  end

  def send_badge (badge_count)
    client = Aws::SNS::Client.new(region: 'us-west-2')
    apns_payload = {"aps" => {"badge" => badge_count}}.to_json
    message = {"default" => "badge count update", "APNS" => apns_payload}.to_json

    client.publish(message: message, target_arn: self.endpoint_arn, message_structure: 'json')
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
