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

  def self.find_by_admin_inventory_id(id)
    inventory = Admin::Inventory.find_by(id: id)
    imprintable = Imprintable::find_by_admin_inventory_id(id)
    color = Color::find_by_admin_color(inventory.color)
    size = Size::find_by_admin_size(inventory.size)
    return self.find_by(
      imprintable_id: (imprintable.nil? ? nil : imprintable.id),
      color_id: (color.nil? ? nil : color.id),
      size_id: (size.nil? ? nil : size.id)
      )
  end
end
