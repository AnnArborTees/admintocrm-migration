FactoryGirl.define do
  factory :admin_payment, :class => 'Admin::Payment' do
    order { |o| o.association(:admin_order) }    
    payment_method "Cash"
    amount 200
  end

end
