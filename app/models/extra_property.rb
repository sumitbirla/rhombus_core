# == Schema Information
#
# Table name: core_extra_properties
#
#  id                  :integer          not null, primary key
#  extra_property_id   :integer          not null
#  extra_property_type :string(255)      not null
#  sort                :integer          default("1"), not null
#  name                :string(255)      not null
#  value               :string(10000)    default(""), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class ExtraProperty < ActiveRecord::Base
  self.table_name = 'core_extra_properties'
  belongs_to :extra_property, polymorphic: true
  
  def is_empty?
    name.blank? && value.blank?
  end
end
