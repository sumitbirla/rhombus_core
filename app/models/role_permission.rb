# == Schema Information
#
# Table name: role_permissions
#
#  id            :integer          not null, primary key
#  role_id       :integer          not null
#  permission_id :integer          not null
#

class RolePermission < ActiveRecord::Base
  self.table_name = 'core_role_permissions'
  belongs_to :role
  belongs_to :permission
end
