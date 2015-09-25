# == Schema Information
#
# Table name: core_settings
#
#  id          :integer          not null, primary key
#  domain_id   :integer          not null
#  section     :string(255)      default(""), not null
#  key         :string(255)      not null
#  value       :string(255)      not null
#  value_type  :string(255)      default(""), not null
#  description :text(65535)
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
    "setting:#{domain_id}:#{section}:#{key}"
  end
  
  def self.get(section, key)
    s = Setting.find_by(section: section, key: key)
    
    return nil if s.nil?
    return s.value.to_i if s.value_type == "number"
    s.value
  end
end
