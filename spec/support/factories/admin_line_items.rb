FactoryGirl.define do
  factory :admin_line_item, :class => 'Admin::LineItem' do
    inventory { |i| i.association(:admin_inventory) } 
    order_id 1  
    product "Test Product"
    description "This is just a test. Stay calm"
    unit_price 2.99
    quantity 22
    taxable true 
    job_id 1  
  end

end
