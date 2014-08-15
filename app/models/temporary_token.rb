# == Schema Information
#
# Table name: temporary_tokens
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  value      :string(255)
#  expires    :datetime
#  created_at :datetime
#  updated_at :datetime
#

class TemporaryToken < ActiveRecord::Base
  self.table_name = 'core_temporary_tokens'
  
  belongs_to :user
end
