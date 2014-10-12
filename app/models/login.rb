# == Schema Information
#
# Table name: logins
#
#  id         :integer          not null, primary key
#  source     :string(255)
#  user_id    :integer          not null
#  timestamp  :datetime         not null
#  ip_address :string(255)      not null
#  user_agent :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class Login < ActiveRecord::Base
  self.table_name = 'core_logins'
  belongs_to :user
  
  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |login|
        csv << login.attributes.values_at(*column_names)
      end
    end
  end
  
end
