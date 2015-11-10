FactoryGirl.define do
  factory :order do 
    name 'Super Order!'
    email 'test@sample.com'
    firstname 'samplename'
    lastname 'lastsample'
    in_hand_by DateTime.now
    terms "the day before yesterday's tomorrow's two days before it's yesterday"
    delivery_method 'stork'
    store {|s| s.association (:store) }
    salesperson {|p| p.association (:user) }
  end
end
