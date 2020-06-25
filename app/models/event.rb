class Event < ApplicationRecord
	self.table_name = 'core_events'
	belongs_to :event_type
end
