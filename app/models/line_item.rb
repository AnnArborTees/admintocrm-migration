class LineItem < ActiveRecord::Base
  has_one :order, through: :job, foreign_key: :jobbable_id
  belongs_to :job, foreign_key: :line_itemable_id
  belongs_to :imprintable_variant, foreign_key: :imprintable_object_id
  belongs_to :line_itemable, polymorphic: true

  validates :job, presence: true
  validates :name, presence: true
  validates :quantity, presence: true
  validates :taxable, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true

  validates :line_itemable, presence: true

  def self.create_from_admin_line_item_and_order(admin_item, order)
    admin_item.set_imprintable
    
    return  self.create(self.params_from_admin_item(admin_item, order))
  end
  
  def self.params_from_admin_item(admin_item, order)
    {
      name: admin_item.product,
      quantity: admin_item.quantity,
      taxable: admin_item.taxable,
      description: admin_item.description,
      unit_price: admin_item.unit_price,
      line_itemable_id: (admin_item.job_id.nil? ? 
        order.id : Job.find_or_create_job_from_admin_job(order, Admin::Job.find(admin_item.job_id)).id),
      line_itemable_type: (admin_item.job_id.nil? ? "Order" : "Job" ),
      imprintable_object_id: admin_item.determine_imprintable_id,
      imprintable_object_type: admin_item.determine_imprintable_type
    }
  end 
end
