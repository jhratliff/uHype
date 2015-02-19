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


  # direct message (chat) alerts
  has_many :chat_alerts
  has_many :chat_alerts_received, :class_name => "ChatAlert", :foreign_key => 'recipient_id'

  def set_default_role
    self.role ||= :user
  end


  def clear_badge
    self.badge_count = 0
    self.save
    self.send_badge(0)
  end

  def increment_badge
    self.badge_count = self.badge_count.to_i
    self.badge_count += 1
    self.save
    self.send_badge(self.badge_count)
  end

  def send_alert (payload)

    if !payload.nil? and payload.length > 0 and !self.endpoint_arn.nil? and self.endpoint_arn.length > 0

      puts ">>>>>>>>>>>>>> Push Notification: #{payload} being sent to #{self.id}: #{self.first_name} #{self.last_name}"

      trimmed_message = payload[0..200]
      client = Aws::SNS::Client.new(region: 'us-west-2')
      apns_payload = {"aps" => {"alert" => trimmed_message}}.to_json
      message = {"default" => "alert message", "APNS" => apns_payload}.to_json



      begin
        client.publish(message: message, target_arn: self.endpoint_arn, message_structure: 'json')

      rescue Aws::Errors::ServiceError => error
        puts "ERROR!!!!! An error of type #{error.class} happened, message is #{error.message}"
        client.delete_endpoint(endpoint_arn: self.endpoint_arn)
        self.endpoint_arn = nil
        self.push_token = nil
        self.action_code = "unregister_push"
        self.save
      end



    end
  end

  def send_badge (badge_count)

    safe_badge_count = badge_count.to_i

    puts ">>>>>>>>>>>>>> Badge: #{safe_badge_count} being sent to #{self.id}: #{self.first_name} #{self.last_name}"

    if !self.endpoint_arn.nil? and self.endpoint_arn.length > 0
      client = Aws::SNS::Client.new(region: 'us-west-2')
      apns_payload = {"aps" => {"badge" => safe_badge_count}}.to_json
      message = {"default" => "badge count update", "APNS" => apns_payload}.to_json

      begin
        client.publish(message: message, target_arn: self.endpoint_arn, message_structure: 'json')
      rescue Aws::Errors::ServiceError => error
        puts "ERROR!!!!! An error of type #{error.class} happened, message is #{error.message}"

        client.delete_endpoint(endpoint_arn: self.endpoint_arn)
        self.endpoint_arn = nil
        self.push_token = nil
        self.action_code = "unregister_push"
        self.save
      end

    end
  end

  def remove_endpoint

  end

  def unseen_chats_count (user_id)
    self.chat_alerts.where(recipient_id: user_id).count()
  end


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
