require 'rails_helper'

describe ImprintHelper, type: :helper do
  
  describe '#determine_color_location(key, imprint_methods)' do
    let (:admin_job) { create(:admin_job, title: "Shirt with 1cb, 1cs, 1c, 2c" ) }
    let!(:order) { create(:order) }
    context 'given a .yml with imprint_phrases and a job title with "Shirt with 1cb, 1cs, 1c, 2c"' do
      it 'should return imprint_methods ["Screen Print,1-C,Back", "Screen Print,1-C,Sleeve", "Screen Print,1-C,Front", "Screen Print,2-C,Front"]' do
        job = Job::find_or_create_from_admin_job(order, admin_job)
        keys = ["1cb", "1cs", "1c", "2c"]
        imprint_methods = []
      
        #without this a 2c would produce a 2cf and 2cb when 2cf is expected
        keys.each do |key|
          if job.name.downcase.include?(key) || job.description.downcase.include?(key)
            if key.last == 'c'#condition from where this function needs to be called
              job.determine_color_location(key, imprint_methods)
            else
              imprint_methods << IMPRINT_MAP[key]
            end#inner if
          end #outer if
        end#end each

        expect(imprint_methods.uniq).to eq(["Screen Print,1-C,Back", "Screen Print,1-C,Sleeve", "Screen Print,1-C,Front", "Screen Print,2-C,Front"])
      end
    end
  end
  
  describe '#determine_DTG_variant(key, imprint_methods)' do

    let (:admin_job) { create(:admin_job, title: "Shirt with DTG-381W") }
    let!(:order) { create(:order) }

    context 'given a .yml with imprint_phrases and a job title with "DTG-381W"' do
      it 'should return imprint_method ["Direct To Garment,Front (White Base)"]' do
        job = Job::find_or_create_from_admin_job(order, admin_job)
        keys = ["dtg", "381"]
        imprint_methods = []

        keys.each do |key, val|
          job.determine_DTG_variant(key, imprint_methods)
        end
        
        expect(imprint_methods.uniq).to eq(["Direct To Garment,Front (White Base)"])
      end
    end

    context 'given a .yml with imprint_phrases and a job title with "782 front and back"' do
      before{ allow(admin_job).to receive(:title) {"DTG 782 front and back"} }

      it 'should return imprint_method ["Direct To Garment,Front,Back (White Base)"]' do
        job = Job::find_or_create_from_admin_job(order, admin_job)

        keys = ["dtg", "782"]
        imprint_methods = []
        
        keys.each do |key, val|
          job.determine_DTG_variant(key, imprint_methods)
        end
        
        expect(imprint_methods.uniq).to eq(["Direct To Garment,Front,Back (White Base)"])
      end
    end
  end
  
  describe '#determine_digital_type(key, imprint_methods)' do
    let(:admin_job) { create(:admin_job, title: "Shirt digital front and back") }
    let!(:order) { create(:order) }

    context 'given a .yml file with imprint_phrases and a job title including "digital front and back' do
      it 'should return imprint_method "[Direct To Garment,Front,Back"]' do
        job = Job::find_or_create_from_admin_job(order, admin_job)
        imprint_methods = []
        key = "digital"

        expect(job.name).to eq(admin_job.title)
        job.determine_digital_type(key, imprint_methods)
        
        expect(imprint_methods).to eq(["Direct To Garment,Front,Back"])
      end
    end

    context 'given a .yml file with imprint_phrases and a job title including "digital on back"' do
      before{ allow(admin_job).to receive(:title) {"shirt digital on back"} }
      
      it 'should return imprint_method ["Direct To Garment,Back"]' do
        
        job = Job::find_or_create_from_admin_job(order, admin_job)
        imprint_methods = []
        key = "digital"

        expect(job.name).to eq(admin_job.title)
        job.determine_digital_type(key, imprint_methods)
        
        expect(imprint_methods).to eq(["Direct To Garment,Back"])
      end
    end
  end
end
