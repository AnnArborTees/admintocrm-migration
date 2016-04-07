class Payment < ActiveRecord::Base
  belongs_to :order, foreign_key: :order_id
  belongs_to :store, foreign_key: :store_id
  belongs_to :salesperson, class_name: "User", foreign_key: :salesperson_id

  validates :payment_method, presence: true
  validates :amount, presence: true
  validates :store, presence: true
  validates :order, presence: true
  validates :salesperson, presence: true

  def self.determine_payment_method(admin_payment)
    case admin_payment.payment_method.downcase
    when "cash"
      return 1
    when "check"
      return 3
    when "credit card", "swiped credit card"
      return 2
    when "paypal"
      return 4
    when "wire transfer"
      return 7
    end
  end

  def self.get_description(admin_order)
    return "#{admin_order.title} for #{admin_order.customer.first_name} #{admin_order.customer.last_name}"
  end

  def self.find_by_admin_order(admin_order)
    admin_payment = Admin::Payment::find_by(order_id: admin_order.id)
    payment = Payment::find_or_initialize_by(order_id: admin_order.id)
    payment.salesperson_id = User::find_or_create_from_admin_order(admin_order).id
    payment.store_id = Store::find_or_create_from_admin_order(admin_order).id
    payment.amount = admin_order.total
    payment.t_description = self.get_description(admin_order)
    payment.payment_method = admin_payment.nil? ? nil : self.determine_payment_method(admin_payment)
    payment.save!
    return payment
  end

# def self.find_by_admin_payment(admin_payment)
#   payment = Payment::find_or_initialize_by(order_id: admin_payment.order_id)
#   payment.salesperson_id = User::find_or_create_from_admin_order(admin_payment.order).id
#   payment.store_id = Store::find_or_create_from_admin_order(admin_payment.order).id
#   payment.payment_method = self.determine_payment_method(admin_payment)
#   payment.amount = admin_payment.amount
#   payment.t_description = self.get_description(admin_payment)
#   return payment
# end
end
