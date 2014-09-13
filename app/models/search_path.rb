class SearchPath < ActiveRecord::Base
  self.table_name = 'core_search_paths'
  validates_presence_of :short_code, :url, :description
  validates_uniqueness_of :short_code
end
