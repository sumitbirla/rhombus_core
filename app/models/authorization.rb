# == Schema Information
#
# Table name: core_authorizations
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string(255)
#  uid        :string(255)
#  name       :string(255)
#  token      :text(65535)
#  secret     :string(255)
#  raw_info   :text(65535)
#  created_at :datetime
#  updated_at :datetime
#

class Authorization < ActiveRecord::Base
  self.table_name = 'core_authorizations'
  validates_presence_of :provider, :uid, :user_id
end
