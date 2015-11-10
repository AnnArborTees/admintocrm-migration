class Admin::Customer < Admin::User
  has_many :orders, class_name: 'Admin::Order', foreign_key: :customer_id
end
