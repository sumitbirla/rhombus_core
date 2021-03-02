# == Schema Information
#
# Table name: core_logs
#
#  id            :integer          not null, primary key
#  data1         :string(255)
#  data2         :string(255)
#  data3         :string(255)
#  event         :string(255)      not null
#  ip_address    :string(255)      not null
#  json_data     :json
#  loggable_type :string(255)      not null
#  timestamp     :datetime         not null
#  loggable_id   :string(32)
#  user_id       :integer
#

class Log < ActiveRecord::Base
  include Exportable

  self.table_name = 'core_logs'
  belongs_to :loggable, polymorphic: true
  belongs_to :user
  before_create :set_timestamp

  def set_timestamp
    self.timestamp = Time.now if timestamp.nil?
  end

  # PUNDIT
  def self.policy_class
    ApplicationPolicy
  end
end
