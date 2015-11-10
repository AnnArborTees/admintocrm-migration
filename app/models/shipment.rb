class Shipment < ActiveRecord::Base
  belongs_to :shipping_method, foreign_key: :shipping_method_id
  belongs_to :shippable, polymorphic: true

  validates :shippable, :shipping_method, 
            :name, :address_1, :city, :state, :zipcode, presence: true

 def self.new_shipment_from_admin_order(admin_order)
   if admin_order.ship_method.downcase.include? "pick up"
     return nil
   end

   self.find_or_initialize_by( 
     name: "#{admin_order.customer.first_name} #{admin_order.customer.last_name}",
     address_1: admin_order.delivery_address_1,
     address_2: admin_order.delivery_address_2,
     address_3: admin_order.delivery_address_3,
     company: admin_order.delivery_company,
     city: admin_order.delivery_city,
     state: admin_order.delivery_state,
     zipcode: admin_order.delivery_zipcode,
     shipping_method_id: ShippingMethod.find_or_create_from_admin_order(admin_order).id
  )

  end
end
