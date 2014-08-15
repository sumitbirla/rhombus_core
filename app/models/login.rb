# == Schema Information
#
# Table name: logins
#
#  id         :integer          not null, primary key
#  source     :string(255)
#  user_id    :integer          not null
#  timestamp  :datetime         not null
#  ip_address :string(255)      not null
#  user_agent :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class Login < ActiveRecord::Base
  self.table_name = 'core_logins'
  belongs_to :user
end
