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

  def is_taxable?
    admin_order = Admin::Order.find_by(id: self.order_id)
    return admin_order.is_tax_exempt ? false : true 
  end
end
