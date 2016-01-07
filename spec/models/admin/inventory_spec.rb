require 'rails_helper'

describe Admin::Inventory, type: :model do
  context 'Associations' do
    it { is_expected.to belong_to(:size).with_foreign_key(:inventory_size_id) }
    it { is_expected.to belong_to(:line).with_foreign_key(:inventory_line_id) }
    it { is_expected.to belong_to(:color).with_foreign_key(:inventory_color_id) }
    it { is_expected.to have_one(:brand).through(:line) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:size) }
    it { is_expected.to validate_presence_of(:color) }
    it { is_expected.to validate_presence_of(:line) }
  end

  let(:inventory) { create(:admin_inventory) }
  describe '#get_brand' do
    context "given a valid admin_inventory with a brand_name of 'Gildan'" do
      it "should return 'Gildan'" do
        expect(inventory.get_brand).to eq("Gildan") 
      end
    end
  end
  describe '#get_color' do
    context "given a valid admin_inventory with a color of 'Green'" do
      it "should return 'Green'" do
        expect(inventory.get_color).to eq("Green")
      end
    end
  end
  describe '#get_size' do
    context "given a valid admin_inventory with a size of 'XL'" do
      it "should return 'XL'" do
        expect(inventory.get_size).to eq("XL")
      end
    end
  end
  describe '#catalog_no' do
    context "given a valid admin_inventory with a catalog_number of '2001'" do
      it "should return '2001'" do
        expect(inventory.catalog_no).to eq("2001")
      end
    end
  end
end
