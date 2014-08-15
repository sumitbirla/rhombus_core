# == Schema Information
#
# Table name: affiliates
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  code           :string(255)
#  slug           :string(255)      default(""), not null
#  featured       :boolean          default(FALSE), not null
#  active         :boolean          default(FALSE), not null
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
#  description    :text
#  created_at     :datetime
#  updated_at     :datetime
#

class Affiliate < ActiveRecord::Base
  self.table_name = 'core_affiliates'
  
  has_many :affiliate_categories
  has_many :categories, through: :affiliate_categories
  validates_presence_of :name
  
  def to_s
    name
  end
end
