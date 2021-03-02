# == Schema Information
#
# Table name: core_event_types
#
#  id          :integer          not null, primary key
#  description :string(255)
#  name        :string(255)      not null
#
class EventType < ActiveRecord::Base
  self.table_name = 'core_event_types'
  validates_presence_of :name
  validates_uniqueness_of :name

  def to_s
    name
  end

  # PUNDIT
  def self.policy_class
    ApplicationPolicy
  end
end
