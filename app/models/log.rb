class Log < ActiveRecord::Base
  include Exportable
  
  self.table_name = 'core_logs'
  belongs_to :loggable, polymorphic: true
  belongs_to :user
  before_create :set_timestamp
  default_scope { order(timestamp: :desc) }
  
  def set_timestamp
    self.timestamp = Time.now if timestamp.nil?
  end
  
  # PUNDIT
  def self.policy_class
    ApplicationPolicy
  end
end
