class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :messaged, :class_name => 'User'
end
