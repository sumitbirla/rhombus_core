class EventType < ActiveRecord::Base

  self.table_name = 'core_event_types'
  validates_presence_of :name

  def to_s
    name
  end

  # PUNDIT
  def self.policy_class
    ApplicationPolicy
  end

end
