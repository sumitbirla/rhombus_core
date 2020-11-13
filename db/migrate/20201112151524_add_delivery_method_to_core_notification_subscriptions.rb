class AddDeliveryMethodToCoreNotificationSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :core_notification_subscriptions, :email, :boolean, null: false, default: false
    add_column :core_notification_subscriptions, :sms, :boolean, null: false, default: false
    add_column :core_notification_subscriptions, :web_push, :boolean, null: false, default: false
    add_column :core_notification_subscriptions, :mobile_push, :boolean, null: false, default: false
    add_column :core_notification_subscriptions, :slack, :boolean, null: false, default: false
    remove_column :core_notification_subscriptions, :notification_delivery_method_id, :integer
  end
end
