require 'rails_helper'

describe Imprint, type: :model do
  context 'Associations' do
    it { is_expected.to belong_to(:job) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:job) }
  end

  describe '::create_from_job_and_method(job, imprint_method)' do
    let(:admin_job) { create(:admin_job, description: "2cf") }
    let(:order) { create(:order) }
    context 'given a job with a title that is not blank and contains an imprint_method 2CF' do
      it 'is expected to return an imprint with description "Screen Print,2 Color,Front"' do
        job = Job::find_or_create_from_admin_job(order, admin_job)
        imprint_methods = []
        imprints = []
        imprint_methods = job.determine_imprint_methods(admin_job)

        imprint_methods.each do |imp|
          imprint = Imprint::create_from_job_and_method(job, imp)
          imprints << imprint
        end
     
        expect(imprints).to_not be_nil
        expect(imprint_methods).to_not be_nil
        expect(imprints.first.description).to eq(imprint_methods.first)
      end
    end
  end
end
