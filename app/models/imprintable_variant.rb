class ImprintableVariant < ActiveRecord::Base
  belongs_to :imprintable
  belongs_to :color
  belongs_to :size
  has_many :line_items, foreign_key: :imprintable_object_id
  has_one :brand, through: :imprintable

  validates :imprintable, presence: true
  validates :size, presence: true
  validates :color, presence: true

  def self.find_or_create_by_admin_inventory(admin_inventory)
    imprintable =  Imprintable.find_or_create_by_admin_inventory(admin_inventory)
    color = Color.find_or_create_by!(name: admin_inventory.color.color)
    size = Size.find_or_create_by_admin_size(admin_inventory.size)
    ImprintableVariant.find_or_create_by!(
                        imprintable_id: imprintable.id,
                        color_id: color.id,
                        size_id: size.id,
                        deleted_at: nil
    )
  end



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

  def self.find_or_create_by_admin_inventory_id(id)
    inventory = Admin::Inventory::find_by(id: id)
    imprintable = Imprintable::find_by_admin_inventory_id(id)
    color = Color::find_by(name: inventory.color.color) unless inventory.nil?
    size = Size::find_by(display_value: inventory.size.size) unless inventory.nil?

    if size && imprintable && color
      variant = self.find_or_initialize_by(
        imprintable_id: imprintable.id,
        color_id: color.id,
        size_id: size.id
        )

      if variant.new_record?
        variant.save
      end
      return variant
    else
      return nil
    end
  end
end
