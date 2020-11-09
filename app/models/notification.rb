# == Schema Information
#
# Table name: core_notifications
#
#  id             :integer          not null, primary key
#  title          :string(255)      not null
#  start_time     :datetime         not null
#  expire_time    :datetime         not null
#  user_id        :integer
#  web_delivery   :boolean          not null
#  email_delivery :boolean          not null
#  sms_delivery   :boolean          not null
#  message        :text(65535)      not null
#  created_at     :datetime
#  updated_at     :datetime
#

class Notification < ActiveRecord::Base
  include Exportable

  self.table_name = 'core_notifications'

  belongs_to :user
  validates_presence_of :title, :start_time, :expire_time, :message
  has_many :views, class_name: 'NotificationStatus'

  # PUNDIT
  def self.policy_class
    ApplicationPolicy
  end
end
