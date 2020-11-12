class Event < ApplicationRecord
  self.table_name = 'core_events'
  belongs_to :event_type

  # Create a system event with specified parameters. This is saved to 'core_events' table.
  #
  # @param event_type_name [Symbol] the type of event to create (eg :order_received)
  # @param data [Object] data associated with this event.  It will be converted to JSON
  # @param expires [TimeWithZone] the time this event expires and will be removed
  #
  # @return [Event] the newly created event.
  #
  def self.transmit(event_type_name, data, expires = 1.day.from_now)
    eid = EventType.find_by(name: event_type_name).id

    # delete any previous identical events which may be redundant now
    Event.where(event_type_id: eid, metadata: data.to_json).delete_all

    # create the new event
    Event.create(event_type_id: eid, metadata: data.to_json, expires: expires)
  end


  # Return a list of users who have subscribed to this event
  #
  # @param [Hash] opts filter options
  # @option opts [Symbol] :delivery_method  restrict to specified delivery method
  # @option opts [Integer] :affiliate_id restrict to users belonging to this Affiliate
  #
  # @return active_record relation of Users
  #
  def subscribers(opts = {})
    users = User.joins(:notification_subscriptions)
                .where("core_notification_subscriptions.event_type_id = ?", event_type_id)

    # filter by delivery method if specified
    if opts[:delivery_method].present?
      unless [:email, :sms, :web_push, :mobile_push, :slack].include?(opts[:delivery_method])
        raise "Unknown delivery method specified: '#{opts[:delivery_method]}'"
      end

      users = users.where(opts[:delivery_method] => true)
    end

    # restricts to users of a certain affiliate if specified
    if opts[:affiliate_id].present?
      users = users.where(affiliate_id: opts[:affiliate_id])
    end

    users
  end

end
