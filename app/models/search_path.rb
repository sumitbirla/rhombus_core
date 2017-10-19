# == Schema Information
#
# Table name: core_search_paths
#
#  id          :integer          not null, primary key
#  short_code  :string(255)      not null
#  url         :string(255)      not null
#  description :string(255)      not null
#  created_at  :datetime
#  updated_at  :datetime
#

class SearchPath < ActiveRecord::Base
  self.table_name = 'core_search_paths'
  validates_presence_of :short_code, :url, :description
  validates_uniqueness_of :short_code
  
  # PUNDIT
  def self.policy_class
    ApplicationPolicy
  end
end
