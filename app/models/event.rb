# == Schema Information
#
# Table name: core_events
#
#  id            :bigint           not null, primary key
#  expires       :datetime         not null
#  json_data     :json
#  processed_at  :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  affiliate_id  :integer
#  event_type_id :integer          not null
#  user_id       :integer
#
class Event < ApplicationRecord
  self.table_name = 'core_events'
  belongs_to :event_type
  belongs_to :affiliate
  belongs_to :user

  # Create a system event with specified parameters. This is saved to 'core_events' table.
  #
  # @param [Symbol] event_type_name the type of event to create (eg :order_received)
  # @param [Hash] opts optional data associated with this event saved to JSON column
  # @options opts [TimeWithZone] :expires the time this event expires and will be removed
  # @options opts [Integer] :user_id the user responsible for this event
  # @options opts [Integer] :affiliate_id the affiliate responsible for this event
  #
  # @return [Event] the newly created event.
  #
  def self.transmit(event_type_name, opts)
    eid = EventType.find_by(name: event_type_name).id

    # no need to store user_id, affiliate_id or expires to the json_data column
    data = opts.without(:user_id, :affiliate_id, :expires)

    # create the new event
    Event.create(event_type_id: eid,
                 user_id: opts[:user_id],
                 affiliate_id: opts[:affiliate_id],
                 expires: opts[:expires] || 3.days.from_now,
                 json_data: data)
  end


  # Return a list of users who have subscribed to this event
  #
  # @param [Hash] opts filter options
  # @option opts [Symbol] :delivery_method  restrict to specified delivery method
  #
  # @return active_record relation of Users
  #
  def subscribers(opts = {})
    users = User.joins(:notification_subscriptions, :role)
                .where("core_notification_subscriptions.event_type_id = ?", event_type_id)

    # filter by delivery method if specified
    if opts[:delivery_method].present?
      # check for valid delivery method types
      unless [:email, :sms, :web_push, :mobile_push, :slack].include?(opts[:delivery_method])
        raise "Unknown delivery method specified: '#{opts[:delivery_method]}'"
      end

      users = users.where("core_notification_subscriptions.#{opts[:delivery_method]}" => true)
    end

    # restricts to users of a certain affiliate (plus admin users) if specified
    unless affiliate_id.nil?
      users = users.where("affiliate_id = ? OR core_roles.super_user = 1", opts[:affiliate_id])
    end

    users
  end

  # PUNDIT
  def self.policy_class
    ApplicationPolicy
  end
end
