# == Schema Information
#
# Table name: core_categories
#
#  id          :integer          not null, primary key
#  code        :string(255)
#  desc1       :text(65535)
#  desc2       :text(65535)
#  entity_type :string(255)      default(""), not null
#  featured    :boolean          default(FALSE), not null
#  hidden      :boolean          default(FALSE), not null
#  image_path  :string(255)
#  name        :string(255)      not null
#  slug        :string(255)      default("")
#  sort        :integer          default(0), not null
#  created_at  :datetime
#  updated_at  :datetime
#  parent_id   :integer
#

class Category < ActiveRecord::Base
  self.table_name = "core_categories"

  has_many :children, -> { order :sort }, class_name: "Category", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Category"

  validates_presence_of :entity_type, :name
  #validates_uniqueness_of :slug, scope: :entity_type

  def to_s
    name
  end

  def cache_key
    "category:#{slug}"
  end

  def level
    return 1 if parent_id.nil?
    return 2 if parent.parent_id.nil?
    return 3 if parent.parent.parant_id.nil?
    raise "Level greater than 3 is unexpected."
  end
end
