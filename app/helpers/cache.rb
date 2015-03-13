module Cache

  def self.setting(*args)
    section = args[0]
    key = args[1]
    
    # if only two parameters are passed, return defeault domain setting
    if args.length == 2
      domain = Domain.find_by(default: true)
      section = args[0]
      key = args[1]
    else
      domain = args[0]
      section = args[1]
      key = args[2]
    end
     
    Rails.cache.fetch("setting:#{domain}:#{section}:#{key}") do 
      s = Setting.find_by(section: section, key: key)
      s.value unless s.nil?
    end
  end
  
  def self.affiliate(slug)
    Rails.cache.fetch("affiliate-#{slug}") do
      Affiliate.find_by(slug: slug)
    end
  end
  
  def self.affiliate_list(category_slug)
    Rails.cache.fetch("affiliate-list-#{category_slug}") do
      cat = Category.find_by(slug: category_slug, entity_type: :affiliate)
      Affiliate.order(:name).where(active: true, id: AffiliateCategory.select(:affiliate_id).where(category_id: cat.id)).load
    end
  end
  
  def self.category(slug, entity_type) 
    Rails.cache.fetch("category:#{slug}:#{entity_type}") do 
      Category.includes(:children).where(slug: slug, entity_type: entity_type).first
    end
  end
  
  def self.category_list(entity_type, parent_id, sort_by) 
    Rails.cache.fetch("categories:#{entity_type}:#{parent_id}:#{sort_by}") do 
      Category.select("id, name, slug, image_path").where(entity_type: entity_type, parent_id: parent_id, hidden: false).order(sort_by).load
    end
  end

end