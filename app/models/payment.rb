class Payment < ActiveRecord::Base
  belongs_to :order, foreign_key: :order_id
  #has_many :orders, foreign_key: :order_id

  validates :payment_method, presence: true
  validates :amount, presence: true
  validates :order, presence: true

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
    else
      return "Trade?" #maybe?
    end 
  end

  def self.find_by_admin_payment(admin_payment)
    payment = Payment::find_by(order_id: admin_payment.order_id)
    payment.payment_method = self.determine_payment_method(admin_payment) unless payment.nil?
    payment.amount = admin_payment.amount unless payment.nil?
    return payment
  end 
end
