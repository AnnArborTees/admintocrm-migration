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

end
