FactoryGirl.define do
  factory :admin_job, :class => 'Admin::Job' do
    id 1
    title "Admin Job Factory"
    description "This is an admin job factory job?  It is awesome."
  end

end
