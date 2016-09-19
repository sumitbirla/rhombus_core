class Log < ActiveRecord::Base
  include Exportable
  
  self.table_name = 'core_logs'
  belongs_to :loggable, polymorphic: true
  belongs_to :user
end
