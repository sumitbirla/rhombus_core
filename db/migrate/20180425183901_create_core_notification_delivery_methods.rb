class CreateCoreNotificationDeliveryMethods < ActiveRecord::Migration
  def change
    create_table :core_notification_delivery_methods do |t|
      t.string :name, null: false
      t.boolean :available, null: false, default: true
    end
  end
end
