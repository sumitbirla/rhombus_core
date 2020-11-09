class NotificationSubscription < ActiveRecord::Base

  self.table_name = 'core_notification_subscriptions'
  validates_presence_of :notification_delivery_method_id, :event_type_id
  belongs_to :notification_delivery_method
  belongs_to :event_type
  belongs_to :user

  # PUNDIT
  def self.policy_class
    ApplicationPolicy
  end

end
