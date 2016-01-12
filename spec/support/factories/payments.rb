FactoryGirl.define do
  factory :payment do
    order { |o| o.association(:order) }
    store { |s| s.association(:store) }
    salesperson { |p| p.association(:user) }
    payment_method "Trade"
    amount 200    
    t_description "John Order"
  end
end
