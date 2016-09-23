# == Schema Information
#
# Table name: core_users
#
#  id               :integer          not null, primary key
#  domain_id        :integer          not null
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
#  approved         :boolean          default(FALSE), not null
#  vip              :boolean          default(FALSE), not null
#  status           :string(16)
#  created_at       :datetime
#  updated_at       :datetime
#

require 'bcrypt'

class User < ActiveRecord::Base
  include Exportable
  
  self.table_name = 'core_users'
  has_many :extra_properties, -> { order "sort, name" }, as: :extra_property
  has_many :logs
  
  attr_accessor :password, :password_confirmation, :current_password

  belongs_to :domain
  belongs_to :role
  belongs_to :affiliate
  validates_presence_of :name, :role_id
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates_uniqueness_of :email, scope: :domain_id
  before_validation :normalize_phone
  
  def authenticate(pwd)
    BCrypt::Password.new(password_digest) == pwd
  end

  def password_confirmed?
    !password.blank? && password == password_confirmation
  end
  
  def to_s
    name
  end
  
  def name_with_id
    "[#{id}] #{name}"
  end

  def record_login(request, source)
    user_agent = UserAgent.parse(request.user_agent)
    
    Log.create(loggable_type: 'Session', 
               loggable_id: request.session.id,
               user_id: id, 
               ip_address: request.remote_ip, 
               event: :created, 
               data1: source,
               data2: user_agent.platform,
               data3: "#{user_agent.browser} #{user_agent.version}")
  end
  
	def normalize_phone
	  self.phone.gsub!(/\D/, '') unless self.phone.nil?
	end
  
  def get_property(name)
    a = extra_properties.find { |x| x.name == name }
    a.nil? ? "" : a.value
  end
  
  def set_property(name, value)
    a = extra_properties.find { |x| x.name == name }
    if a.nil?
      self.extra_properties.build(name: name, value: value) unless value.blank?
    else
      if value.blank?
        a.destroy
      else
        a.value = value
      end
    end
  end

end
