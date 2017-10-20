# == Schema Information
#
# Table name: core_logs
#
#  id            :integer          not null, primary key
#  timestamp     :datetime         not null
#  loggable_type :string(255)      not null
#  loggable_id   :string(32)
#  user_id       :integer
#  ip_address    :string(255)      not null
#  event         :string(255)      not null
#  data1         :string(255)
#  data2         :string(255)
#  data3         :string(255)
#

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
