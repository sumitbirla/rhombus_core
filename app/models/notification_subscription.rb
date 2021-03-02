# == Schema Information
#
# Table name: core_notification_subscriptions
#
#  id            :integer          not null, primary key
#  email         :boolean          default(FALSE), not null
#  mobile_push   :boolean          default(FALSE), not null
#  slack         :boolean          default(FALSE), not null
#  sms           :boolean          default(FALSE), not null
#  web_push      :boolean          default(FALSE), not null
#  created_at    :datetime
#  updated_at    :datetime
#  event_type_id :integer          not null
#  user_id       :integer          not null
#
class NotificationSubscription < ActiveRecord::Base
  self.table_name = 'core_notification_subscriptions'
  validates_presence_of :event_type_id
  belongs_to :event_type
  belongs_to :user

  validates_uniqueness_of :user_id, scope: :event_type_id

  # Determine if one or more delivery methods have been specified
  def delivery_methods_specified?
    email || sms || web_push || mobile_push || slack
  end

  # PUNDIT
  def self.policy_class
    ApplicationPolicy
  end
end
