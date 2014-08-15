# == Schema Information
#
# Table name: notifications
#
#  id             :integer          not null, primary key
#  title          :string(255)      not null
#  start_time     :datetime         not null
#  expire_time    :datetime         not null
#  user_id        :integer
#  web_delivery   :boolean          not null
#  email_delivery :boolean          not null
#  sms_delivery   :boolean          not null
#  message        :text             not null
#  created_at     :datetime
#  updated_at     :datetime
#

class Notification < ActiveRecord::Base
  self.table_name = 'core_notifications'
  
  belongs_to :user
  validates_presence_of :title, :start_time, :expire_time, :message
  has_many :views, class_name: 'NotificationStatus'
end
