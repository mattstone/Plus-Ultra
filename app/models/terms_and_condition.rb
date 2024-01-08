class TermsAndCondition < ApplicationRecord
  
  has_many :users

  has_rich_text :content 
  
  validates :content, presence: true
  
  enum :status, { draft: 0, published: 100 }, prefix: true

  def self.latest 
    TermsAndCondition.where(status: "published").order(created_at: :desc).last
  end
  
  def published?
    self.status_published?
  end
  
  def draft?
    self.status_draft?
  end
  
end
