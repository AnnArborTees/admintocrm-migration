class Brand < ActiveRecord::Base
  has_many :imprintables
  has_many :imprintable_variants, through: :imprintables

  validates :name, presence: true

  def name_in_pig_latin
    last_char = self.name[0]
    self.name[0] = ''
    self.name << last_char
    self.name << 'ay'
    self.name = self.name.capitalize
  end

  def self.find_or_create_from_admin_brand_name(ab_name)
    brand = Brand.find_or_create_by(name: ab_name)
    brand.save
    return brand
  end

end
