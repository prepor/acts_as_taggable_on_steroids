class Tag < ActiveRecord::Base
  has_many :taggings
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  cattr_accessor :destroy_unused
  self.destroy_unused = false
  
  # LIKE is used for cross-database case-insensitivity
  def self.find_or_create_with_like_by_name(name)
    find(:first, :conditions => ["name = ?", name]) || create( :name => name, :slug_name => Slug.strip_diacritics( name ) )
  end
  def self.find_or_create_with_like_by_slug_name(name)
    find(:first, :conditions => ["slug_name = ?", Slug.strip_diacritics( name )]) || create( :name => name, :slug_name => Slug.strip_diacritics( name ) )
  end
  
  def ==(object)
    super || (object.is_a?(Tag) && name == object.name)
  end
  
  def to_s
    name
  end
  def to_param
    self.slug_name
  end
  
  def count
    read_attribute(:count).to_i
  end
end
