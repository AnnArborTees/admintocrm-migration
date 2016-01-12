FactoryGirl.define do
  factory :admin_proof_image, :class => 'Admin::ProofImage' do
    filename "test.jpg"
    job_id 200 
  end

end
