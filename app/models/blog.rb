class Blog < ApplicationRecord
  has_rich_text :teaser 
  has_rich_text :content 

  enum :status, { draft: 0, published: 100 }, prefix: true
  
  validates :title, presence:   true
  validates :title, uniqueness: true

  validates :slug,  uniqueness: true
    
  before_create :set_slug
  before_update :set_slug
  
  private 
  
  def set_slug
    # TODO this could be better..
    self.slug = self.title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/,'')
  end
  
end  
