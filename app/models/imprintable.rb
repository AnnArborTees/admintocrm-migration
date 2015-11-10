class Imprintable < ActiveRecord::Base
  has_many :imprintable_variants
  belongs_to :brand

  validates :brand, presence: true
  validates :style_catalog_no, presence: true
  validates :style_name, presence: true

  def full_name
    "#{brand.name} #{self.style_catalog_no} - #{self.style_name}"
  end
end
