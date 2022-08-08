class Product < ApplicationRecord
  before_save :create_slug
  validates :name, :description, :quantity, :price, presence: true
  scope :newest, ->{order created_at: :desc}

  private 
    
  def create_slug
    suffix = Digest::MD5.hexdigest(name + SecureRandom.uuid)[0..5]
    self.slug = [ERB::Util.url_encode(name), suffix].join("-")
  end
end
