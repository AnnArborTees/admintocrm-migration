class ShippingMethod < ActiveRecord::Base
  has_many :shipments, foreign_key: :shipping_method_id

  validates :name, presence: true

  def self.find_or_create_from_admin_order(admin_order)
     s_method = self.find_or_initialize_by(
     name: admin_order.ship_method
    )
   
    s_method.save if s_method.valid?
    return s_method if s_method.valid? 
  end
end
