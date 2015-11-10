FactoryGirl.define do
  factory :job do
    name "Stefan (regular) job"
    description "This is stefan's job!"
    order { |o| o.association(:order) }
  end

end
