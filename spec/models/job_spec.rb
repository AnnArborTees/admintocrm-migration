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

  describe '#determine_imprint_methods(admin_job)' do
    let(:admin_job) { create(:admin_job, title: "Quarter Zip Black Applique 1c ") }

    context "given a .yml file containing filtering data and an admin_job with description containing '1c'" do
      it "should return an array with data from 1c  '[Screen Print,1-C,Front]'" do
        job = Job.new_job_from_admin_job(admin_job)
        imprint_methods = job.determine_imprint_methods
        
        expect(job.name).to eq(admin_job.title)
        expect(imprint_methods).to_not be_empty
        expect(imprint_methods).to eq(["Screen Print,1-C,Front"])
      end
    end
  end

  describe 'imprint_helper_extension' do
    let(:admin_job) { create(:admin_job) }
    let(:job) { Job::new_job_from_admin_job(admin_job) }
    let(:imprint_methods) { imprint_methods = [] }
    
    context 'job class can use helper methods' do

      it 'has access to imprint_helper method determine_DTG_variant' do
        job.description = "shirt that is dtg on front"        
        key = 'dtg'
        job.determine_DTG_variant(key, imprint_methods)

        expect(job.description).to eq("shirt that is dtg on front")
        expect(imprint_methods).to eq(["Direct To Garment,Front"])   
      end
      
      it 'has access to imprint_helper method determine_digital_type' do
        job.description = "shirt with digital on front and on back"
        key = 'digital'
        job.determine_digital_type(key, imprint_methods)
        
        expect(job.description).to eq("shirt with digital on front and on back")
        expect(imprint_methods).to eq(["Direct To Garment,Front,Back"])
      end

      it 'has access to imprint_helper method determine_color_location' do
        job.name = "shirt with 2c, 2cb and 3cb"
        keys = ["2c", "2cb", "3c", "3cb"]

        keys.each do |k|
          job.determine_color_location(k, imprint_methods)
        end

        expect(job.name).to eq("shirt with 2c, 2cb and 3cb")
        expect(imprint_methods).to eq(["Screen Print,2-C,Front", "Screen Print,2-C,Back", "Screen Print,3-C,Back"])
      end
    end
  end
end
