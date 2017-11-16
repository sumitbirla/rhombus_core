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
    #puts ">>>>>  #{resource}:#{action}"
    super_user || permissions.any? { |x| x.resource == resource.to_s && x.action == action.to_s } 
  end
  
  def has_any_permission?(section)
    super_user || permissions.any? { |x| x.section == section }
  end
  
  # Add read/create/update/destroy/index permissions for given section and resource if not aleady exists
  def self.create_permissions(section, resource, actions = [:read, :create, :update, :destroy, :index])
    actions.each { |x| Permission.find_or_create_by(section: section, resource: resource, action: x) }
  end
  
  # PUNDIT
  def self.policy_class
    ApplicationPolicy
  end
      
end
