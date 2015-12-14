require 'rails_helper'

describe Admin::ProofImage, type: :model do
  context 'Associations' do
    it { is_expected.to belong_to(:job).with_foreign_key(:job_id) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:filename) }
    it { is_expected.to validate_presence_of(:job_id) }
  end

  describe '#file_path' do
    let(:proofs) { create(:admin_proof_image) }
    context 'given a proof_image with filename "test.jpg" and job_id 1000' do
      it "should produce file_path 'http://s3.amazonaws.com/admin.annarbortshirtcompany.com/proof_images/1000/test.jpg'" do
        expect(proofs.filename).to eq("test.jpg")
        expect(proofs.file_path).to eq("http://s3.amazonaws.com/admin.annarbortshirtcompany.com/proof_images/1000/test.jpg")
      end
    end
  end
end
