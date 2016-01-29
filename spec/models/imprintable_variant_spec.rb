require 'rails_helper'

describe ImprintableVariant, type: :model do
  context 'Associations' do
    it {is_expected.to belong_to(:imprintable)}
    it {is_expected.to have_many(:line_items)}
    it {is_expected.to belong_to(:color)}
    it {is_expected.to belong_to(:size)}
    it {is_expected.to have_one(:brand).through(:imprintable)}
    end

  context 'Validations' do
    it{is_expected.to validate_presence_of(:imprintable)}
    it{is_expected.to validate_presence_of(:color)}
    it{is_expected.to validate_presence_of(:size)}
  end

  let(:inventory) { create(:admin_inventory) }
  let!(:size) { create(:size, display_value: inventory.size.size) }
  let!(:color) { create(:color, name: inventory.color.color) }
  let!(:brand) { create(:brand, name: inventory.brand.name) }
  let!(:imprintable) { create(:imprintable, brand_id: brand.id) }
  let!(:imprintable_variant) { create(:imprintable_variant, imprintable_id: imprintable.id, size_id: size.id, color_id: color.id) } 
  
  describe '::find_by_admin_inventory_id(id)' do
    context "given an admin_inventory with matching data to imprintable_variant" do

      before{allow(inventory.size).to receive(:size){size.name}}
      it "should return an imprintable_variant with [color_name: 'Green', size: 'XL', 
      catalog_no: '2001', brand_name: 'Gildan'" do
     
        imp_variant = ImprintableVariant::find_or_create_by_admin_inventory_id(inventory.id)
        expect(imp_variant).to_not be_nil
        expect(imp_variant.get_brand).to eq(inventory.get_brand)
        expect(imp_variant.get_size).to eq(inventory.get_size)
        expect(imp_variant.get_color).to eq(inventory.get_color)
        expect(imp_variant.get_catalog_no).to eq(inventory.catalog_no)  
      end
    end
    
    context "given an admin_inventory without matching data to imprintable_variant" do
     
      before{ allow(inventory).to receive(:id) {200}} 
      it "should return nil" do
        inventory
        imp_variant = ImprintableVariant::find_or_create_by_admin_inventory_id(inventory.id)
        expect(imp_variant).to be_nil
      end
    end
  end
end
