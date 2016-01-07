FactoryGirl.define do
  factory :payment do
    order { |o| o.association(:order) }
    payment_method "Trade"
    amount 200    
  end

end
