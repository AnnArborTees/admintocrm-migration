namespace :order do
  desc "TODO"
  task create_crm_orders: :environment do
    Admin::Order.limit(10).each do |admin_order|
      byebug
      order = Order.create_from_admin_order(admin_order)
      order.create_shipment_from_admin_order(admin_order)
    end
  end

end
