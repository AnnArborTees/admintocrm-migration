FactoryGirl.define do
  factory :admin_customer, :class => 'Admin::Customer' do
    first_name "Russ"
    last_name "Gale" 
    email "rgale@sample.com"
  end

end
