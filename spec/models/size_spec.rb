require 'rails_helper'

describe Size, type: :model do
  context 'Associations' do
    it {is_expected.to have_many(:imprintable_variants)}
  end 

  context 'Validations' do
    it {is_expected.to validate_presence_of(:name)}
  end

  describe '::find_by_admin_size(admin_size)' do
    let!(:admin_size) { create(:admin_inventory_size) }
    let!(:size) { create(:size) }
    context 'given an admin_size with size "XL"' do
      it 'should return a size with name "XL"' do
        size = Size::find_by_admin_size(admin_size)
        expect(size.class).to eq(Size)
        expect(size.display_value).to eq(admin_size.size)        
      end
    end
  end
end
