# == Schema Information
#
# Table name: core_domains
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  url        :string(255)      not null
#  default    :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  data1      :string(255)
#  data2      :string(255)
#

class Domain < ActiveRecord::Base
  self.table_name = 'core_domains'
  
  validates_presence_of :name, :url
  
  def to_s
    name
  end
end
