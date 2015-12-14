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

  def get_unique_brand
    brand = Admin::Brand.find_by(name: self.name)
    return brand
  end
end
