# == Schema Information
#
# Table name: permissions
#
#  id         :integer          not null, primary key
#  section    :string(255)      not null
#  resource   :string(255)      not null
#  action     :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class Permission < ActiveRecord::Base
  self.table_name = 'core_permissions'
  
  validates_presence_of :section, :resource, :action
  validates_uniqueness_of :action, scope: [:section, :resource]
end
