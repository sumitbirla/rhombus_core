# == Schema Information
#
# Table name: notification_statuses
#
#  id              :integer          not null, primary key
#  notification_id :integer          not null
#  user_id         :integer          not null
#  view_time       :datetime         not null
#  dismiss_time    :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

class NotificationStatus < ActiveRecord::Base
  self.table_name = 'core_notification_statuses'
end
