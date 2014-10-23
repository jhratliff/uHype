class User < ActiveRecord::Base
  acts_as_token_authenticatable
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?

  belongs_to :school

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
