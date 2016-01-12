class Discount < Payment
  default_scope { where("amount < ?", 0) }
  belongs_to :order, foreign_key: :order_id
  belongs_to :salesperson, class_name: "User", foreign_key: :salesperson_id

  validates :payment_method, presence: true
  validates :refunded, presence: true
  validates :amount, presence: true
  validates :store, presence: true
  validates :order, presence: true
  validates :salesperson, presence: true
  validates :t_description, presence: true

  def self.find_by_admin_payment(admin_payment)
    discount = Discount::find_or_initialize_by(order_id: admin_payment.order_id)
    discount.refunded = true
    discount.salesperson_id = User::find_or_create_from_admin_order(admin_payment.order).id
    discount.store_id = Store::find_or_create_from_admin_order(admin_payment.order).id
    discount.payment_method = self.determine_payment_method(admin_payment)
    discount.amount = admin_payment.amount
    discount.t_description = self.get_description(admin_payment) 
    return discount
  end
end
