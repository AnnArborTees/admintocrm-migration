FactoryGirl.define do
  factory :admin_admin, :class => 'Admin::Admin' do
    first_name "Nate"
    last_name "Polaski"
    salesperson true
    email 'Nate@sample.com'
  end
end
