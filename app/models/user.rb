# == Schema Information
#
# Table name: core_users
#
#  id               :integer          not null, primary key
#  approved         :boolean          default(FALSE), not null
#  avatar_url       :string(255)
#  birth_date       :date
#  email            :string(255)      not null
#  extension        :string(255)
#  gender           :string(255)
#  locale           :string(255)
#  location         :string(255)
#  name             :string(255)      not null
#  password_digest  :string(255)
#  phone            :string(255)
#  pin              :string(255)
#  referral_clicks  :integer          default(0), not null
#  referral_key     :string(255)
#  referral_signups :integer          default(0), not null
#  referred_by      :integer
#  status           :string(16)
#  time_zone        :string(255)
#  vip              :boolean          default(FALSE), not null
#  created_at       :datetime
#  updated_at       :datetime
#  affiliate_id     :integer
#  domain_id        :integer          not null
#  external_id      :string(255)
#  role_id          :integer          not null
#

require 'bcrypt'

class User < ActiveRecord::Base
  include Exportable
  acts_as_taggable_on :tags
  self.table_name = 'core_users'

  attr_accessor :password, :password_confirmation, :current_password

  has_many :webauthn_credentials, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :extra_properties, -> { order "sort, name" }, as: :extra_property, dependent: :destroy
  has_many :logs, dependent: :destroy
  has_many :notification_subscriptions, dependent: :destroy

  accepts_nested_attributes_for :notification_subscriptions, allow_destroy: true

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

  def admin?
    role.super_user
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

  # Return the last DateTime the user logged in
  def last_login
    log = Log.where(user_id: id, loggable_type: 'Session').last
    log ? log.timestamp : nil
  end

  # PUNDIT
  def self.policy_class
    ApplicationPolicy
  end

  def has_permission?(resource, action)
    role.has_permission?(resource, action)
  end

  def has_any_permission?(section)
    role.has_any_permission?(section)
  end
end
