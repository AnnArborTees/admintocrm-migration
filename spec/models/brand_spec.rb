require 'rails_helper'

describe Brand, type: :model do
  context 'Associations' do
    it {is_expected.to have_many(:imprintable_variants).through(:imprintables)}
    it {is_expected.to have_many(:imprintables)}
  end

  context 'Validations' do 
    it { is_expected.to validate_presence_of(:name) }
  end

  context '#name_in_pig_latin' do 

    let(:brand) { create(:brand)}

    it 'returns the name with the first letter removed, added to the end, and ay added to it' do
      expect(brand.name_in_pig_latin).to eq("Ildangay")
    end
  end

  describe '::find_or_create_from_admin_brand_name(ab_name)' do
    
    let(:admin_brand) { create(:admin_brand) }
    
    context 'given an admin_brand that has no matching brand' do
      it 'should return a new brand with admin_brand name' do
        not_found = Brand::find_by(name: admin_brand.name)
        brand = Brand::find_or_create_from_admin_brand_name(admin_brand.name)

        expect(not_found).to be_nil
        expect(brand.name).to eq(admin_brand.name)
      end
    end

    context 'given an admin_brand that has matching brand' do
      
      before { allow(admin_brand).to receive(:name) {"Gildan"} }

      it 'should return that brand' do
        brand = Brand::find_or_create_from_admin_brand_name(admin_brand.name) 
        expect(brand.name).to eq(admin_brand.name)
      end
    end
  end
end
