FactoryGirl.define do
  factory :admin_proof_image, :class => 'Admin::ProofImage' do
    filename "test.jpg"
    id 1000 
    job_id 200 
  end

end
