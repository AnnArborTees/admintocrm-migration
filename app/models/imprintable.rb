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

  def brand_name
    "#{brand.name}"
  end

  def self.find_or_create_by_admin_inventory(admin_inventory)
    brand = Brand.find_or_create_by(name: admin_inventory.brand.name)
    return Imprintable.find_by(brand_id: brand.id, style_catalog_no: admin_inventory.catalog_number) if Imprintable.exists?(brand_id: brand.id, style_catalog_no: admin_inventory.catalog_number)
    Imprintable.create(
                  brand_id: brand.id,
                  style_name: admin_inventory.name,
                  style_catalog_no: admin_inventory.catalog_number,
                  style_description: admin_inventory.description,
                  base_price:  0.00,
                  xxl_upcharge:  0.00,
                  xxxl_upcharge:  0.00,
                  xxxxl_upcharge:  0.00,
                  xxxxxl_upcharge:  0.00,
                  xxxxxxl_upcharge:  0.00,
                  retail:  false
    )
  end

  def self.find_by_admin_inventory_id(id)
    inventory = Admin::Inventory.find_by(id: id)
    return self.find_by_admin_inventory(inventory) unless inventory.nil?
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
end
