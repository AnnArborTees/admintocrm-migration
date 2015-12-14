class ImprintableVariant < ActiveRecord::Base
  belongs_to :imprintable
  belongs_to :color
  belongs_to :size
  has_many :line_items, foreign_key: :imprintable_object_id
  has_one :brand, through: :imprintable

  validates :imprintable, presence: true
  validates :size, presence: true
  validates :color, presence: true

  def get_brand
    "#{imprintable.brand.name}"
  end

  def get_color
    "#{self.color.name}"
  end

  def get_size
    "#{self.size.name}"
  end

  def get_catalog_no
    "#{self.imprintable.style_catalog_no}"
  end

  def self.get_color(admin_inventory)
    if admin_inventory
      return Color::find_by(name: "#{admin_inventory.get_color}")
    end
  end

  def self.get_size(admin_inventory)
    if admin_inventory
      return Size::find_by("name = ? or display_value = ?", admin_inventory.get_size, admin_inventory.get_size)
    end
  end
  
  def self.find_by_admin_inventory_id(id)
    inventory = Admin::Inventory.find_by(id: id)
    imprintable = Imprintable::find_by_admin_inventory_id(id)
    color = self.get_color(inventory)
    size = self.get_size(inventory)
    
    if imprintable && color && size
      return self.find_by(
        imprintable_id: imprintable.id,
        color_id: color.id,
        size_id: size.id
      )
    else
      return nil
    end  
  end

end
