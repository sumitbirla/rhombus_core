# == Schema Information
#
# Table name: settings
#
#  id          :integer          not null, primary key
#  section     :string(255)      default(""), not null
#  key         :string(255)      not null
#  value       :string(255)      not null
#  value_type  :string(255)      default(""), not null
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Setting < ActiveRecord::Base
  self.table_name = 'core_settings'
  belongs_to :domain
  validates_presence_of :section, :key, :value, :value_type
  validates_uniqueness_of :key, scope: [:domain_id, :section]
  
  def to_s
    value
  end
  
  def cache_key
    "setting:#{section}:#{key}"
  end
end
