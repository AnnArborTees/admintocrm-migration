class LineItem < ActiveRecord::Base
  has_one :order, through: :job, foreign_key: :jobbable_id
  belongs_to :job, foreign_key: :line_itemable_id
  belongs_to :imprintable_variant, foreign_key: :imprintable_object_id

  validates :job, presence: true
  validates :name, presence: true
  validates :quantity, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  validates :decoration_price, presence: true

  def determine_subtotal
    return sprintf('%.2f',((self.quantity * self.unit_price).to_f)).to_f
  end

  def determine_tax(subtotal)
    return self.taxable ? sprintf('%.2f', (subtotal * 0.06)).to_f : 0
  end

  def set_imprintables(admin_item)
    @imprintable = Imprintable::find_by_admin_inventory_id(admin_item.inventory_id)
    @variant = ImprintableVariant::find_by_admin_inventory_id(admin_item.inventory_id) unless @imprintable.nil?
  end
  
  def self.create_from_admin_line_and_job(admin_item, job)
    return self.create(self.params_from_admin_item_and_job(admin_item, job)) 
  end

  def get_variant
    return @variant
  end

  def get_imprintable
    return @imprintable
  end

  def self.params_from_admin_item_and_job(admin_item, job)
    {
      name: admin_item.product,
      quantity: admin_item.quantity,
      taxable: admin_item.is_taxable?,
      description: admin_item.description,
      unit_price: admin_item.unit_price,
      decoration_price: admin_item.unit_price,
      imprintable_price: 0.00,
      #line_itemable_id: (admin_item.job_id.nil? ? 
      #order.id : Job.find_or_create_from_admin_job(order, Admin::Job.find(admin_item.job_id)).id),
      #line_itemable_type: (admin_item.job_id.nil? ? "Order" : "Job" ),
      line_itemable_id: admin_item.job_id.nil? ? Order::find_by(id: admin_item.order_id).id : admin_item.job_id,
      line_itemable_type: admin_item.job_id.nil? ? "Order" : "Job",
      url: Imprintable::find_by_admin_inventory_id(admin_item.inventory_id).supplier_link, 
      imprintable_object_id: admin_item.inventory_id.nil? ? 
        nil : ImprintableVariant::find_by_admin_inventory_id(admin_item.inventory_id).id, 
      imprintable_object_type: admin_item.inventory_id.nil? ? "Imprintable" : "Imprintable Variant"
    }
  end
end
