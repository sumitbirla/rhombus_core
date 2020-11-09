class Event < ApplicationRecord
  self.table_name = 'core_events'
  belongs_to :event_type

  def self.transmit(event_type_name, data, expires = 1.day.from_now)
    eid = EventType.find_by(name: event_type_name).id

    # delete any previous events which may be redundant now
    Event.where(event_type_id: eid, metadata: data.to_json).delete_all

    # create the new event
    Event.create(event_type_id: eid, metadata: data.to_json, expires: expires)
  end


  # Return a list of users who have subscribed to this event
  #
  # Parameters:
  # 	- delivery_method 		restrict to certain delivery method (:email, :sms, :desktop, :slack etc.)
  # 	- affiliate_id				restrict only users belonging to this affiliate
  #
  # Returns:
  # 	-	active_record relation to retrieve array of Users
  #
  def subscribers(h = {})
    users = User.joins(:notification_subscriptions)
                .where("core_notification_subscriptions.event_type_id = ?", event_type_id)

    # delivery method specified
    if h[:delivery_method].present?
      delivery_method = NotificationDeliveryMethod.find_by(name: h[:delivery_method])
      users = users.where("core_notification_subscriptions.notification_delivery_method_id = ?", delivery_method.id)
    end

    # restricts to users of a certain affiliate
    if h[:affiliate_id].present?
      users = users.where(affiliate_id: h[:affiliate_id])
    end

    users
  end

end
