# == Schema Information
#
# Table name: core_logins
#
#  id         :integer          not null, primary key
#  timestamp  :datetime         default("CURRENT_TIMESTAMP"), not null
#  source     :string(255)
#  user_id    :integer          not null
#  ip_address :string(255)      not null
#  user_agent :string(255)      not null
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
