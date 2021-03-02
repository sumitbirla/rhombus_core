# == Schema Information
#
# Table name: core_role_permissions
#
#  id            :integer          not null, primary key
#  permission_id :integer          not null
#  role_id       :integer          not null
#
# Indexes
#
#  index_role_permissions_on_permission_id  (permission_id)
#  index_role_permissions_on_role_id        (role_id)
#

class RolePermission < ActiveRecord::Base
  self.table_name = 'core_role_permissions'
  belongs_to :role
  belongs_to :permission
end
