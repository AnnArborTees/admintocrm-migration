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
  let(:variant) { create(:imprintable_variant)}
  describe '::get_color(inventory)' do
    let!(:color) { create(:color) }
    context 'Given an admin_inventory with color.name of "Green"' do
      it 'get_color_id should get the color "Green" from crm colors' do
        
        expect(ImprintableVariant::get_color(inventory).name).to eq("Green")
      end
    end
  end  

  describe 'get_size(inventory)' do
    let!(:size) { create(:size) }
    context 'Given an admin_inventory with size.size of "XL"'do
      it 'get_size should return XL' do
        expect(ImprintableVariant::get_size(inventory).name).to eq("XL") 
      end
    end
  end


  let(:inventory) { create(:admin_inventory) }
  let(:impvar)  { create(:imprintable_variant) }
  describe '::find_by_admin_inventory_id(id)' do
    context "given an admin_inventory with matching data to imprintable_variant" do
      it "should return an imprintable_variant with [color_name: 'Green', size: 'XL', 
      catalog_no: '2001', brand_name: 'Gildan'" do

        impvar

        imp_var = ImprintableVariant::find_by_admin_inventory_id(inventory.id)
        expect(imp_var).to_not be_nil
        expect(imp_var.get_brand).to eq(inventory.get_brand)
        expect(imp_var.get_size).to eq(inventory.get_size)
        expect(imp_var.get_color).to eq(inventory.get_color)
        expect(imp_var.get_catalog_no).to eq(inventory.catalog_no)  
      end
    end
    context "given an admin_inventory without matching data to imprintable_variant" do
      let(:size) { create(:size, name: "XXL")}
      it "should return nil" do
     
        size 
        imp_var = ImprintableVariant::find_by_admin_inventory_id(inventory.id)
        expect(imp_var).to be_nil
      end
    end
  end
end
