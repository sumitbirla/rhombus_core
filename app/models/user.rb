# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  affiliate_id     :integer
#  role_id          :integer          not null
#  email            :string(255)      not null
#  password_digest  :string(255)
#  name             :string(255)      not null
#  phone            :string(255)
#  birth_date       :date
#  gender           :string(255)
#  time_zone        :string(255)
#  locale           :string(255)
#  location         :string(255)
#  avatar_url       :string(255)
#  pin              :string(255)
#  referred_by      :integer
#  referral_key     :string(255)
#  referral_clicks  :integer          default(0), not null
#  referral_signups :integer          default(0), not null
#  approved         :boolean
#  vip              :boolean
#  created_at       :datetime
#  updated_at       :datetime
#

require 'bcrypt'

class User < ActiveRecord::Base
  self.table_name = 'core_users'
  
  attr_accessor :password, :password_confirmation, :current_password

  belongs_to :role
  belongs_to :affiliate
  validates_presence_of :name, :role_id
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates_uniqueness_of :email


  def authenticate(pwd)
    BCrypt::Password.new(password_digest) == pwd
  end

  def password_confirmed?
    !password.blank? && password == password_confirmation
  end
  
  def to_s
    name
  end

  def record_login(request, source)
    Login.create user_id: id, source: source, timestamp: DateTime.now,
                 ip_address: request.remote_ip, user_agent: request.user_agent
  end

end
