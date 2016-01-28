class Imprintable < ActiveRecord::Base
  has_many :imprintable_variants
  belongs_to :brand

  validates :brand, presence: true
  validates :style_catalog_no, presence: true
  validates :style_name, presence: true

  def full_name
    "#{brand.name} #{self.style_catalog_no} - #{self.style_name}"
  end

  def get_url
    "#{self.supplier_link}"
  end
  
  def self.find_by_admin_inventory_id(id)
    inventory = Admin::Inventory.eager_load(:brand).find_by(id: id)
    return self.find_or_create_from_admin_line(inventory.line) unless inventory.nil?
  end
 
  def self.find_by_admin_inventory(inventory)
    if (brand = Brand::find_by(name: inventory.brand.name))
      return imprintable = Imprintable::find_by(
        style_catalog_no: inventory.catalog_no,
        brand_id: brand.id
      )
    else
      return nil
    end
  end

  def self.find_or_create_from_admin_line(admin_line)
    brand = Brand::find_or_create_from_admin_brand_name(admin_line.brand.name)
    imprintable = Imprintable::find_or_initialize_by(brand_id: brand.id, style_catalog_no: admin_line.catalog_number)

    if imprintable.new_record?
      imprintable.style_name = admin_line.name
      imprintable.style_description = admin_line.description
      imprintable.base_price = 0.00
      imprintable.xxl_upcharge = 0.00
      imprintable.xxxl_upcharge = 0.00
      imprintable.xxxxl_upcharge = 0.00
      imprintable.xxxxxl_upcharge = 0.00
      imprintable.xxxxxxl_upcharge = 0.00
      imprintable.retail = false
      imprintable.save
    end 

    return imprintable
  end

  def brand_name
    "#{brand.name}"
  end
end
