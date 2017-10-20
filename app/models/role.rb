# == Schema Information
#
# Table name: core_roles
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  default      :boolean          not null
#  super_user   :boolean          not null
#  created_at   :datetime
#  updated_at   :datetime
#  landing_page :string(255)
#

class Role < ActiveRecord::Base
  include Exportable
  self.table_name = 'core_roles'
  
  has_many :role_permissions
  has_many :permissions, through: :role_permissions
  has_many :users
  
  validates_uniqueness_of :name
  
  def to_s
    name
  end
  
  def has_permission?(resource, action)
    super_user || permissions.exists?(resource: resource, action: action)
  end
  
  def has_any_permission?(section)
    super_user || permissions.exists?(section: section)
  end
  
  # PUNDIT
  def self.policy_class
    ApplicationPolicy
  end
      
end
