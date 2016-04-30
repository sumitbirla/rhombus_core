class ExtraProperty < ActiveRecord::Base
  self.table_name = 'core_extra_properties'
  belongs_to :extra_property, polymorphic: true
end
