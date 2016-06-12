# == Schema Information
#
# Table name: core_roles
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  default    :boolean          not null
#  super_user :boolean          not null
#  created_at :datetime
#  updated_at :datetime
#

class Role < ActiveRecord::Base
  include Exportable
  self.table_name = 'core_roles'
  
  has_many :role_permissions
  has_many :permissions, through: :role_permissions
  has_many :users
  
  validates_uniqueness_of :name
end
