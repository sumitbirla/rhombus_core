# == Schema Information
#
# Table name: core_domains
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  url        :string(255)      not null
#  default    :boolean          default(FALSE), not null
#  data1      :string(255)
#  data2      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Domain < ActiveRecord::Base
  include Exportable
  
  self.table_name = 'core_domains'
  validates_presence_of :name, :url
  
  def to_s
    name
  end
  
end
