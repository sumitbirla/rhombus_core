class CreateCoreNotificationSubscriptions < ActiveRecord::Migration
  def change
    create_table :core_notification_subscriptions do |t|
      t.integer :user_id, null: false
      t.integer :notification_delivery_method_id, null: false
      t.integer :event_type_id, null: false
    end
  end
end
