class Admin::Inventory < ActiveRecord::Base
  belongs_to :size, class_name: "Admin::InventorySize", foreign_key: :inventory_size_id
  belongs_to :line, class_name: "Admin::InventoryLine", foreign_key: :inventory_line_id
  belongs_to :color, class_name: "Admin::InventoryColor", foreign_key: :inventory_color_id
  belongs_to :brand, class_name: "Admin::Brand", foreign_key: :brand_id

  validates :brand, presence: true
  validates :size, presence: true
  validates :color, presence: true
  validates :line, presence: true

  def get_brand
    "#{brand.name}"
  end
  
  def get_color
    "#{color.color}"
  end 
  
  def get_size
    "#{size.size}"
  end

  def catalog_no
    "#{self.catalog_number}"
  end
end
