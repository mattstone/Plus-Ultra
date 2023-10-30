class Blog < ApplicationRecord
  has_rich_text :teaser 
  has_rich_text :content 
  has_one_attached :hero_image, dependent: :destroy do |attachable|
    attachable.variant :thumb,   resize_to_limit: [100, 100]
    attachable.variant :preview, resize_to_limit: [300, 300]
  end
  
  enum :status, { draft: 0, published: 100 }, prefix: true
  
  validates :title, presence:   true
  validates :title, uniqueness: true

  validates :slug,  uniqueness: true
  
  validate :acceptable_image
    
  before_create :set_slug
  before_update :set_slug
  
  def hero_image?
    return false if self.hero_image.nil?
    self.hero_image.url.nil? == false
  end
  
  private 
  
  def set_slug
    # TODO this could be better - need to remove .!%&* as well
    self.slug = self.title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/,'')
  end
  
  def acceptable_image 
    return unless hero_image.attached?

    if hero_image.blob.byte_size > 10.megabytes
      errors.add(:hero_image, "is too big (file size limit = 10 Megabytes)")
    end
    
    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(hero_image.content_type)
      errors.add(:hero_image, "must be a JPEG or PNG")
    end    
  end
  
end  
