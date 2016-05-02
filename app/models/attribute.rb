# == Schema Information
#
# Table name: core_attributes
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  entity_type :string(255)      default(""), not null
#  notes       :string(255)
#  hidden      :boolean          default("0"), not null
#  metadata    :string(255)
#  data_type   :string(255)      not null
#  sort        :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Attribute < ActiveRecord::Base
  self.table_name = 'core_attributes'
  validates_presence_of :name, :entity_type, :data_type, :sort
end
