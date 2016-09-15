# == Schema Information
#
# Table name: core_logins
#
#  id         :integer          not null, primary key
#  timestamp  :datetime         default(NULL), not null
#  source     :string(255)
#  user_id    :integer          not null
#  ip_address :string(255)      not null
#  user_agent :string(255)      not null
#

class Login < ActiveRecord::Base
  include Exportable
  
  self.table_name = 'core_logins'
  belongs_to :user
end
