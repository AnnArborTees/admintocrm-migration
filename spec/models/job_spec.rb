require 'rails_helper'

describe Job, type: :model do
  context 'Associations' do
    it { is_expected.to belong_to(:order) }
    it { is_expected.to have_many(:line_items) }
    it { is_expected.to have_many(:imprints) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:order) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
  end

  describe '::create_job_from_admin_job(admin_job)' do

      let(:admin_job) { create(:admin_job) }
      let(:job) { Job::new_job_from_admin_job(admin_job) }

    context 'admin_job has valid title' do

      it 'initializes a job with name and description from admin_job' do
        expect(job.class).to eq(Job)
        expect(job.name).to eq(admin_job.title)
        expect(job.description).to eq(admin_job.description)
      end
    end
   
    context 'admin_job has invalid data' do
        
      before { allow(admin_job).to receive (:title) {nil} }

      it "doesn't create/initialize a job" do
        expect(job).to be_nil
      end
    end
  end
end
