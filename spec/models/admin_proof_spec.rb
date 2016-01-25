require 'rails_helper'

describe AdminProof, type: :model do
  context 'Association' do
    it { is_expected.to belong_to(:order).with_foreign_key(:order_id) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:order_id) }
  end

  describe '::create_from_admin_job_and_proof(admin_job, proof)' do
    
    let(:order) { create(:order, imported_from_admin: true) }
    let(:admin_job) { create(:admin_job, custom_order_id: order.id) }
    let(:proof) { create(:admin_proof_image) }

    context 'Given an order that is imported from admin' do
      it 'should create the resulting admin_proofs associated with the order' do
        if order.imported_from_admin
          admin_proof = AdminProof::create_from_admin_job_and_proof(admin_job, proof)
        end
       expect(admin_proof.file_url).to eq(proof.file_path) 
      end
    end

    context 'Given an order that is not imported from admin' do
      
      before{ allow(order).to receive(:imported_from_admin) {false} }

      it 'should not create an admin_proof' do
        if order.imported_from_admin
          admin_proof = AdminProof::create_from_admin_job_and_proof(admin_job, proof)
        end

        expect(admin_proof).to be_nil
      end
    end
  end
end
