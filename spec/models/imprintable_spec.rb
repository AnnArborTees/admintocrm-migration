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

  let(:imprint) { create(:imprintable) }

  describe '#full_name' do
    context "given an imprintable with style_catalog_no '2001' and style_name 'V Neck' and brand name 'Gildan'" do
      it "returns 'brand_name style_catalog_no - style_name'" do
        expect(imprint.full_name).to eq("Gildan 2001 - Unisex Fine Jersey Long Sleeve Tee")        
      end
    end
  end

  describe '#brand_name' do
    context 'Given an imprintable with a brand name Gildan' do
      it 'brand_name should return Gildan' do
        expect(imprint.brand_name).to eq("Gildan")
      end
    end
  end
  
  describe '::find_or_create_from_inventory_line(admin_inventory)' do
    
    let!(:admin_inventory) { create(:admin_inventory) }
    let!(:imprintable2) { create(:imprintable) }
    
    context 'given an inventory line with brand.id 3 and catalog_number "2001"' do
      it 'should return imprintable with matching data' do
        imprintable = Imprintable::find_by_admin_inventory(admin_inventory)
        expect(imprintable).to_not be_nil
        expect(imprintable.class).to eq(Imprintable)
        expect(imprintable.brand_name).to eq(admin_inventory.line.brand.name)
        expect(imprintable.style_catalog_no).to eq(admin_inventory.line.catalog_number)
      end
    end
  end
 
  describe '::find_by_admin_inventory_id(id)' do
    
    let!(:inventory) { create(:admin_inventory) }
    
    context "given an admin_inventory with data that matches an imprintable" do
      
      let!(:imprintable2) { create(:imprintable,
                               style_name: "Unisex Fine Jersey Long Sleeve Tee", style_catalog_no: "2001") }
      
      it "should return imprintable with data [brand_name: 'Gildan', style_catalog_no: '2001']" do
        imprintable = Imprintable::find_by_admin_inventory_id(inventory.id)
        expect(imprintable).to_not be_nil
        expect(imprintable.style_name).to eq(inventory.name)
        expect(imprintable.style_catalog_no).to eq(inventory.catalog_no)
      end
    end

    context "given an admin_inventory with data that doesn't match an imprintable" do
      
      let!(:imprint) { create(:imprintable, style_catalog_no: "FB2001") }
      
      it "should return nil" do
        imprintable = Imprintable::find_by_admin_inventory_id(inventory.id)
        expect(imprintable).to be_nil
      end
    end
  end
end
