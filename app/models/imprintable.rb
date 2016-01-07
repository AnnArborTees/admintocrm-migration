class Imprintable < ActiveRecord::Base
  has_many :imprintable_variants
  belongs_to :brand

  validates :brand, presence: true
  validates :style_catalog_no, presence: true
  validates :style_name, presence: true

  def full_name
    "#{brand.name} #{self.style_catalog_no} - #{self.style_name}"
  end
  
  def self.find_by_admin_inventory_id(id)
    inventory = Admin::Inventory.eager_load(:brand).find_by(id: id)
    return Imprintable.find_by_admin_inventory(inventory) unless inventory.nil?
  end
  
  def self.find_by_admin_inventory(inventory)
    if (brand = Brand::find_by(name: inventory.get_brand))
      return imprintable = Imprintable::find_by(
        style_catalog_no: inventory.catalog_no,
        brand_id: brand.id
      )
    else
      return nil
    end
  end

  def brand_name
    "#{brand.name}"
  end
end
