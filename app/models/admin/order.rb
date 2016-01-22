class Admin::Order < ActiveRecord::Base
  default_scope { where(type: "customOrder") }
  self.inheritance_column = :_type_disabled

  belongs_to :customer, class_name: 'Admin::Customer', foreign_key: :customer_id
  belongs_to :admin, class_name: 'Admin::Admin', foreign_key: :administrator_id
  has_many :payments, class_name: "Admin::Payment", foreign_key: :order_id
  has_many :jobs, class_name: "Admin::Job", foreign_key: :custom_order_id
  has_many :line_items, class_name: "Admin::LineItem", through: :jobs, foreign_key: :order_id

  validates :customer_id, presence: true
  validates :administrator_id, presence: true
  validates :type, presence: true
end
