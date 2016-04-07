class ShippingMethod < ActiveRecord::Base
  has_many :shipments, foreign_key: :shipping_method_id

  ADMIN_SHIPMENTS_MAP = {
    'AATC Delivery' => 5,
    'Amazon FBA' => 16,
    'Economy Shipping' => 1,
    'FedEx'            => 2,
    'International Economy Shipping'  => 8,
    'Priority International Shipping'  => 6,
    'UPS'                               => 2,
    'UPS 2nd Day Air'                   => 4,
    'UPS 3 Day Select'                  => 3,
    'UPS Ground'                        => 2,
    'UPS Next Day AM'                   => 9,
    'UPS Next Day Saver'                => 10,
    'UPS Next Day with Express Processing'=> 10,
    'ups_2nd_day_air'                   => 4,
    'ups_ground'                        => 2,
    'ups_next_day_air'                  => 18,
    'ups_standard'                      => 2,
    'USPS'                              => 1,
    'USPS Express'                      => 7,
    'USPS First Class or Priority'      => 1,
    'usps_express'                      => 7,
    'usps_first_class'                  => 1,
    'usps_priority'                     => 6,
    'Worldwide Expedited'               => 8
  }

  validates :name, presence: true

  def self.find_or_create_from_admin_order(admin_order)
     s_method = self.find_or_initialize_by(
     name: admin_order.ship_method
    )

    s_method.save if s_method.valid?
    return s_method if s_method.valid?
  end

  def self.find_from_admin_order(admin_order)
    ADMIN_SHIPMENTS_MAP[admin_order.ship_method] || 1
  end
end
