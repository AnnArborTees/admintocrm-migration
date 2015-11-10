class Admin::Admin < Admin::User
  has_many :orders, class_name: 'Admin::Order', foreign_key: :administrator_id

  validates :salesperson, presence: true
end
