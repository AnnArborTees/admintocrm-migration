FactoryGirl.define do
 factory :admin_order, :class => 'Admin::Order' do 
    title 'Old Crappy Admin Order'    
    type "customOrder"
    ship_method "Pick Up (Ypsilanti)"
    terms "5050"
    delivery_deadline Date.new(2015, 11, 18)
    delivery_address_1 '28 Edison Ave'
    delivery_city 'Ypsilanti'
    delivery_state 'MI'
    delivery_zipcode '48197'
    customer { |c| c.association(:admin_customer) }
    admin { |a| a.association(:admin_admin)}
 end
end
