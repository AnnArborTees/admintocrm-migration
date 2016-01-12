FactoryGirl.define do
  factory :line_item do
    job { |j| j.association(:job) }
    name "Test LineItem"
    quantity 10
    description "This is just a test"
    unit_price 100
    decoration_price 15
  end

end
