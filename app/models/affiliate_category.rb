# == Schema Information
#
# Table name: core_affiliate_categories
#
#  id           :integer          not null, primary key
#  affiliate_id :integer          not null
#  category_id  :integer          not null
#

class AffiliateCategory < ActiveRecord::Base
  self.table_name = 'core_affiliate_categories'

  belongs_to :affiliate
  belongs_to :category
end
