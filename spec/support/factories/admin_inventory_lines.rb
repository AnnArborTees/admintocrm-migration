FactoryGirl.define do
  factory :admin_inventory_line, :class => 'Admin::InventoryLine' do
    name 'test'
    catalog_number '2001'
    brand { |b| b.association(:admin_brand) }
  end

end
