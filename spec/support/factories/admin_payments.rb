FactoryGirl.define do
  factory :admin_payment, :class => 'Admin::Payment' do
    order { |o| o.association(:admin_order) }    
    admin { |a| a.association(:admin_admin) }
    first_name "Stefan"
    last_name "Gale"
    payment_method "Cash"
    amount 200
  end
end
