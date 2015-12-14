FactoryGirl.define do
  factory :admin_inventory, :class => 'Admin::Inventory' do
    id 1 
    catalog_number '2001'
    brand { |b| b.association(:admin_brand) }
    size { |s| s.association(:admin_inventory_size) }
    color { |c| c.association(:admin_inventory_color) }
    line { |l| l.association(:admin_inventory_line) }
    name 'Unisex Fine Jersey Long Sleeve Tee'
  end
end
