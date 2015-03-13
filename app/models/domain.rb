class Domain < ActiveRecord::Base
  self.table_name = 'core_domains'
  
  validates_presence_of :name, :url
  
  def to_s
    name
  end
end
