require 'rails_helper'

describe Imprintable, type: :model do
  context 'Associations' do
    it {is_expected.to have_many(:imprintable_variants)}
    it {is_expected.to belong_to(:brand)}
  end

  context 'Validations' do
    it {is_expected.to validate_presence_of(:brand)}
    it {is_expected.to validate_presence_of(:style_catalog_no)}
    it {is_expected.to validate_presence_of(:style_name)}
  end

  context '#full_name' do
    
    let(:imprintable) { create(:imprintable) }

    it 'returns the brand_name style_catalog_no - style_name' do
      expect(imprintable.full_name).to eq("Gildan 2001 - V Neck")        
    end
  end

end
