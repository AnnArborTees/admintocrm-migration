require 'rails_helper'

describe Size, type: :model do
  context 'Associations' do
    it { is_expected.to have_many(:imprintable_variants) }
  end 

  context 'Validations' do
    it { is_expected.to validate_presence_of(:display_value) }
  end

  describe '::find_or_create_by_admin_size_name(admin_size.size)' do
    
    let(:admin_size) { create(:admin_inventory_size) }
    let!(:size) { create(:size) }
    
    context 'given an admin_size with out matching data in crm size' do
      it 'should return a new size with admin_size information in crm' do
        no_matching_display = Size::find_by(display_value: admin_size.size) 
        no_matching_name = Size::find_by(name: admin_size.size)
        size = Size::find_or_create_by_admin_size_name(admin_size.size)
        
        expect(no_matching_display).to be_nil
        expect(no_matching_name).to be_nil
        expect(size.display_value).to eq(admin_size.size)
      end
    end

    context 'given an admin_size with matching data in crm size' do
      
      before { allow(admin_size).to receive(:size) {size.display_value} }

      it 'should return the matching data from crm size' do
        size = Size::find_or_create_by_admin_size_name(admin_size.size)
        
        expect(size.display_value).to eq(admin_size.size)
        expect(size.name).to eq(admin_size.size)  
      end
    end
  end
end
