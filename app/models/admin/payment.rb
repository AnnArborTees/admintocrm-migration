class Admin::Payment < ActiveRecord::Base
  belongs_to :order, class_name: "Admin::Order", foreign_key: :order_id
  #has_many :orders, class_name: "Admin::Order", foreign_key: :order_id
  
 #validates :check_number, presence: true
 #validates :credit_card_number, presence: true
 #validates :credit_card_type, presence: true
 #validates :credit_card_exp_date, presence: true
 #validates :first_name, presence: true
 #validates :last_name, presence: true
 #validates :address_1, presence: true
 #validates :city, presence: true
 #validates :state, presence: true
 #validates :zipcode, presence: true
  validates :payment_method, presence: true
  validates :amount, presence: true
  validates :order, presence: true
end
