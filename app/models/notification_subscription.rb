class NotificationSubscription < ActiveRecord::Base

  self.table_name = 'core_notification_subscriptions'
  validates_presence_of :event_type_id
  belongs_to :event_type
  belongs_to :user

  validates_uniqueness_of :user_id, scope: :event_type_id

  # PUNDIT
  def self.policy_class
    ApplicationPolicy
  end

end
