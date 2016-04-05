class User < ActiveRecord::Base
  establish_connection Rails.configuration.database_configuration[ [Rails.env, "users"].join('_') ]

  has_many :orders, foreign_key: :salesperson_id

  validates :email, presence: true

  def self.find_or_create_from_admin_order(admin_order)

    first_name = admin_order.admin.first_name
    last_name = admin_order.admin.last_name
    email = admin_order.admin.email.gsub("annarbortshirtcompany.com", "annarbortees.com")
    user = User.find_or_initialize_by(email: email)
    return user if user.persisted?

    user.first_name = first_name
    user.last_name = last_name

    user.save
    user
  end
end
