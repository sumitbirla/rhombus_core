# == Schema Information
#
# Table name: core_printers
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  url         :string(255)      not null
#  print_count :integer          default(0), not null
#  model       :string(64)
#  location    :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Printer < ActiveRecord::Base
  self.table_name = "core_printers"
  validates_presence_of :name, :url
  
  def to_s
    name
  end
    
end

