# == Schema Information
#
# Table name: categories
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  entity_type :string(255)      default(""), not null
#  parent_id   :integer
#  hidden      :boolean          default(FALSE), not null
#  slug        :string(255)      not null
#  sort        :integer          default(0), not null
#  desc1       :text
#  desc2       :text
#  desc3       :text
#  image_path  :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Category < ActiveRecord::Base
  self.table_name = "core_categories"
  
  has_many :children, -> { order :sort }, class_name: "Category", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Category"
  
  validates_presence_of :entity_type, :name, :sort, :slug
  validates_uniqueness_of :slug, scope: :entity_type
  
  def cache_key
    "category:#{slug}"
  end
end
