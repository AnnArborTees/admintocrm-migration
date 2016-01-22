class Admin::LineItem < ActiveRecord::Base
  belongs_to :inventory, class_name: "Admin::Inventory", foreign_key: :inventory_id
  belongs_to :job, class_name: "Admin::Job", foreign_key: :job_id
  has_one :order, class_name: "Admin::Order", through: :job, foreign_key: :order_id

  validates :inventory, presence: true
  validates :order_id, presence: true
  validates :product, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  validates :quantity, presence: true
  validates :taxable, presence: true
  validates :job_id, presence: true 

 #def set_imprintable
 #  @imprintable = Imprintable::find_by_admin_inventory_id(self.inventory_id)
 #  @variant = ImprintableVariant::find_by_admin_inventory_id(self.inventory_id) unless @imprintable.nil?
 #end

 #def get_imprintable
 #  @imprintable
 #end

 #def get_imprintable_variant
 #  @variant
 #end

 #def determine_imprintable_id
 #  if @imprintable.nil?
 #    return nil
 #  elsif @variant.nil?
 #    return @imprintable.id
 #  else
 #    return @variant.id
 #  end
 #end 

 #def determine_imprintable_price
 #  return (self.get_imprintable.nil? ? nil : self.get_imprintable.base_price)
 #end

 #def determine_decoration_price
 #  return (self.determine_imprintable_price.nil? ? 
 #          self.unit_price : self.unit_price - self.determine_imprintable_price)
 #end

 #def determine_imprintable_type
 #  if @imprintable.nil?
 #    return nil
 #  elsif @variant.nil?
 #    return "Imprintable"
 #  else
 #    return "Imprintable Variant"
 #  end
 #end
  def is_taxable?
    admin_order = Admin::Order.find_by(id: self.order_id)
    return admin_order.is_tax_exempt ? false : true 
  end
end
