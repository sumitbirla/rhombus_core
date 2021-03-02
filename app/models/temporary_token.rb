# == Schema Information
#
# Table name: core_temporary_tokens
#
#  id         :integer          not null, primary key
#  expires    :datetime
#  value      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#
# Indexes
#
#  index_temporary_tokens_on_user_id  (user_id)
#

class TemporaryToken < ActiveRecord::Base
  self.table_name = 'core_temporary_tokens'
  belongs_to :user
end
