class NotificationDeliveryMethod < ActiveRecord::Base

  self.table_name = 'core_notification_delivery_methods'
  validates_presence_of :name, :available

  def to_s
    name
  end

  # PUNDIT
  def self.policy_class
    ApplicationPolicy
  end

end
