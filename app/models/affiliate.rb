# == Schema Information
#
# Table name: core_affiliates
#
#  id                  :integer          not null, primary key
#  active              :boolean          default(FALSE), not null
#  api_key             :string(255)
#  city                :string(255)
#  code                :string(255)
#  contact_person      :string(255)
#  country             :string(255)
#  description         :text(65535)
#  disable_invoicing   :boolean          default(FALSE), not null
#  discount_percent    :decimal(5, 2)    default(0.0), not null
#  email               :string(255)
#  enable_edi          :boolean          default(FALSE), not null
#  fax                 :string(255)
#  featured            :boolean          default(FALSE), not null
#  free_shipping       :boolean          default(FALSE), not null
#  logo                :string(255)
#  markup_percent      :decimal(5, 2)    default(0.0), not null
#  name                :string(255)      not null
#  payment_terms       :string(255)
#  phone               :string(255)
#  requires_approval   :boolean          default(FALSE), not null
#  slug                :string(255)      default("")
#  state               :string(255)
#  street1             :string(255)
#  street2             :string(255)
#  summary             :text(65535)
#  tax_exempt          :boolean          default(FALSE), not null
#  transaction_fee     :decimal(5, 2)    default(0.0), not null
#  transaction_percent :decimal(5, 2)    default(0.0), not null
#  website             :string(255)
#  zip                 :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  tax_id              :string(255)
#

class Affiliate < ActiveRecord::Base
  include Exportable
  acts_as_taggable_on :tags
  self.table_name = 'core_affiliates'

  before_save :set_api_key

  has_many :affiliate_categories, dependent: :destroy
  has_many :categories, through: :affiliate_categories
  has_many :extra_properties, -> { order "sort, name" }, as: :extra_property
  has_many :users
  has_many :comments, as: :commentable, dependent: :destroy

  validates_presence_of :name
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, unless: Proc.new { |a| a.email.blank? }
  validates_uniqueness_of :code, unless: Proc.new { |a| a.code.blank? }
  validates_uniqueness_of :name

  # following used only during signup (not stored in database)
  attr_accessor :password, :password_confirmation

  def to_s
    name
  end

  def set_api_key
    self.api_key = SecureRandom.uuid if api_key.blank?
  end

  def address_as_text(opts = {})
    delim = opts[:delimiter] || "\n"

    address = street1.presence || ""
    address = address + delim + street2 unless street2.blank?
    address = address + delim + city unless city.blank?
    address = address + ', ' + state unless state.blank?
    address = address + ', ' + zip unless zip.blank?
    unless opts[:skip_country]
      address += delim + Country[country].to_s unless country.blank?
    end
    address.html_safe unless address.nil?
  end

  def valid_password?

    if password.blank?
      errors.add(:password, "cannot be blank")
      return false
    end

    if password.length < 5
      errors.add(:password, "is too short")
      return false
    end

    if password != password_confirmation
      errors.add(:base, "passwords do not match")
      return false
    end

    return true
  end

  def get_property(name)
    a = extra_properties.find { |x| x.name == name }
    a.nil? ? "" : a.value
  end

  def set_property(name, value)
    a = extra_properties.find { |x| x.name == name }
    if [true, false].include? value
      value = (value ? "Yes" : "No")
    end

    if a.nil?
      self.extra_properties.build(name: name, value: value) unless value.blank?
    else
      if value.blank?
        a.destroy
      else
        a.update(value: value)
      end
    end
  end

  # PUNDIT
  def self.policy_class
    ApplicationPolicy
  end

end
