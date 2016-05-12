# == Schema Information
#
# Table name: core_affiliates
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  code           :string(255)
#  slug           :string(255)      default(""), not null
#  featured       :boolean          default("0"), not null
#  active         :boolean          default("0"), not null
#  tax_id         :string(255)
#  contact_person :string(255)
#  street1        :string(255)
#  street2        :string(255)
#  city           :string(255)
#  state          :string(255)
#  zip            :string(255)
#  country        :string(255)
#  phone          :string(255)
#  fax            :string(255)
#  email          :string(255)
#  website        :string(255)
#  logo           :string(255)
#  description    :text(65535)
#  payment_terms  :string(255)
#  facebook_page  :string(255)
#  summary        :text(65535)
#  created_at     :datetime
#  updated_at     :datetime
#  price_formula  :string(255)
#

class Affiliate < ActiveRecord::Base
  self.table_name = 'core_affiliates'
  
  has_many :affiliate_categories
  has_many :categories, through: :affiliate_categories
  has_many :extra_properties, -> { order "sort, name" }, as: :extra_property
  validates_presence_of :name, :street1, :city, :state, :zip, :country, :contact_person, :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates_uniqueness_of :name
  
  # following used only during signup (not stored in database)
  attr_accessor :password, :password_confirmation
  
  def to_s
    name
  end
  
  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |aff|
        csv << aff.attributes.values_at(*column_names)
      end
    end
  end
  
  def address_as_text(opts = {})
    
    delim = opts[:delimiter] || "\n"
    
    address = street1
    address = address + delim + street2 unless street2.blank?
    address = address + delim + city unless city.blank?
    address = address + ', ' + state unless state.blank?
    address = address + ', ' + zip unless zip.blank?
    address
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
  
end
