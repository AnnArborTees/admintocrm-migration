class User < ActiveRecord::Base
  has_many :orders, foreign_key: :salesperson_id
  
  validates :email, presence: true
  
  def self.find_or_create_from_admin_order(admin_order)
    
    first_name = admin_order.admin.first_name
    last_name = admin_order.admin.last_name
    email = admin_order.admin.email

    if !email.nil?
      if email.include?"ricky@"
        first_name = "Ricky"
        last_name = "Winowiecki"
      elsif email.include?"chantal@"
        first_name = "Chantal"
        last_name = "Laurens"
      end
    end

    user = User.find_or_initialize_by(
      email: email,
      first_name: first_name, 
      last_name: last_name
    )

    user.save if user.valid?
    return user if user.valid?
    return nil unless user.valid?
  end
end
