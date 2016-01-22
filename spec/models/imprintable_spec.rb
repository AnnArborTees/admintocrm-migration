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

  describe '#get_url' do
    let(:imprintable) { create(:imprintable) }
    context 'given an imprintable with a supplier_link of "www.test.com"' do
      it 'should return "www.test.com"' do
        expect(imprintable.get_url).to eq(imprintable.supplier_link) 
      end
    end
    context 'given an imprintable with a nil supplier_link' do
      before { allow(imprintable).to receive(:supplier_link) {nil} }
      it 'should return nil' do
        expect(imprintable.get_url).to be_blank
      end
    end
  end
  
  describe '::find_or_create_from_admin_line(admin_line)' do
    
    let!(:admin_line) { create(:admin_inventory_line) }
    
    context 'given an admin_inventory_line with out matching data in crm' do
      it 'should return a new imprintable with matching data in crm' do
        not_found = Imprintable::find_by(brand_id: admin_line.brand.id, style_catalog_no: admin_line.catalog_number)
        imprintable = Imprintable::find_or_create_from_admin_line(admin_line)
        expect(not_found).to be_nil
        expect(imprintable.class).to eq(Imprintable)
        expect(imprintable.brand_name).to eq(admin_line.brand.name)
        expect(imprintable.style_catalog_no).to eq(admin_line.catalog_number)
      end
    end
  end
 
  describe '::find_by_admin_inventory_id(id)' do
    
    let(:inventory) { create(:admin_inventory) }
    let(:brand) { create(:brand, name: inventory.brand.name) }
    let(:find_imprintable) { create(:imprintable, brand_id: brand.id, style_catalog_no: inventory.catalog_no) }
    
    context "given an admin_inventory with data that matches an imprintable" do

      it "should return imprintable with data [brand_name: 'Gildan', style_catalog_no: '2001']" do
        find_imprintable
        imprintable = Imprintable::find_by_admin_inventory_id(inventory.id)
        expect(imprintable).to_not be_nil
        expect(imprintable.style_name).to eq(inventory.name)
        expect(imprintable.style_catalog_no).to eq(inventory.catalog_no)
      end
    end

   #context "given an admin_inventory with data that doesn't match an imprintable" do
   # 
   #  before { allow(inventory.line.brand).to receive(:name){"Gildan"} }

   #  it "should return nil" do
   #    find_imprintable
   #    brand
   #    imprintable = Imprintable::find_by_admin_inventory_id(inventory.id)
   #    expect(imprintable).to be_nil
   #  end
   #end
  end
end
