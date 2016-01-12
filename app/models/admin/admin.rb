class Admin::Admin < Admin::User
  default_scope { where(type: "Administrator") }
  has_many :orders, class_name: 'Admin::Order', foreign_key: :administrator_id
  has_many :payments, class_name: "Admin::Payment", foreign_key: :user_id

  validates :salesperson, presence: true
end
