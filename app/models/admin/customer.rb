class Admin::Customer < Admin::User
  establish_connection Admin::database_name

  has_many :orders, class_name: 'Admin::Order', foreign_key: :customer_id
end
