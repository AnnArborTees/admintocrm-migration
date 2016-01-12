require 'rails_helper'

describe Admin::LineItem, type: :model do
  
  context 'Associations' do
    it { is_expected.to belong_to(:inventory).with_foreign_key(:inventory_id) }
    it { is_expected.to belong_to(:job).with_foreign_key(:job_id) }
    it { is_expected.to have_one(:order).through(:job).with_foreign_key(:custom_order_id) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:inventory) }
    it { is_expected.to validate_presence_of(:order_id) }
    it { is_expected.to validate_presence_of(:product) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:unit_price) }
    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_presence_of(:taxable) }
    it { is_expected.to validate_presence_of(:job_id) }
  end

  describe '#determine_imprintable_id' do
    
    let!(:admin_line) { create(:admin_line_item) }
    let!(:imprintable) { create(:imprintable, id: 72) }
    
    context 'given an admin_line_item' do
      it 'should return imprintable_id of 72' do
        admin_line.set_imprintable
        expect(admin_line.determine_imprintable_id).to eq(72) 
      end
    end
    
    context 'given an admin_line_item with inventory_id of nil' do
      
      before{allow(admin_line).to receive(:inventory_id) {nil}}
      
      it 'should return nil' do
        admin_line.set_imprintable
        expect(admin_line.determine_imprintable_id).to be_nil
      end
    end
    
    context 'given an admin_line_item with inventory_id of 614 and an imprintable and an imprintable variant' do
    
      let!(:imprintable_variant) {create(:imprintable_variant, id: 22, imprintable_id: 72) }
      
      it 'should return imprintable_variant_id 22' do
        admin_line.set_imprintable
        expect(admin_line.determine_imprintable_id).to eq(22)
      end
    end
  end

  describe '#set_imprintable' do

    let!(:admin_line) { create(:admin_line_item) }
    let!(:imprintable) { create(:imprintable, id: 72) }
    
    context 'given an admin_line_item with inventory id 614 and an imprintable' do
      it 'should return a not nil @imprintable and @imprintable should contain data 
      "[id: 72, style_name: "Unisex Fine Jersey Long Sleeve Tee", style_catalog_no: "2001", brand_id: 1]"' do
        admin_line.set_imprintable
        @imprintable = admin_line.get_imprintable
        @variant = admin_line.get_imprintable_variant
        expect(@imprintable).to_not be_nil
        expect(@variant).to be_nil
        expect(@imprintable.style_name).to eq(imprintable.style_name)
        expect(@imprintable.brand_id).to eq(imprintable.brand_id)
        expect(@imprintable.style_catalog_no).to eq(imprintable.style_catalog_no)
      end
    end
    
    context 'given an admin_line_item with inventory id nil' do
      
      before { allow(admin_line).to receive(:inventory_id) {nil} }
      
      it 'should return @imprintable of nil and @variant of nil' do
        admin_line.set_imprintable
        @variant = admin_line.get_imprintable_variant
        @imprintable = admin_line.get_imprintable

        expect(@variant).to be_nil
        expect(@imprintable).to be_nil
      end
    end
    
    context 'given an admin_line_item with inventory id 614 and an imprintable and an imprintable variant' do
      
      let!(:variant) { create(:imprintable_variant, id: 22, imprintable_id: 72)}
      
      it 'should return @variant not nil and @variant should contain data
      "[id: 22, imprintable_id: 72, size_id: 1, color_id: 1]"' do
        admin_line.set_imprintable
        @variant = admin_line.get_imprintable_variant
        @imprintable = admin_line.get_imprintable

        expect(@imprintable).to_not be_nil
        expect(@variant).to_not be_nil
        expect(@variant.imprintable_id).to eq(@imprintable.id)
        expect(@variant.size_id).to eq(variant.size_id)
        expect(@variant.color_id).to eq(variant.color_id)
      end
    end
  end

  describe '#determine_imprintable_type' do
    
    let!(:admin_line) { create(:admin_line_item) }
    let!(:imprintable) { create(:imprintable, id: 72) }
    
    context 'given an admin_line_item with inventory_id of 614 ' do
      it 'should return imprintable_type of "Imprintable' do
        admin_line.set_imprintable
        expect(admin_line.determine_imprintable_type).to eq("Imprintable") 
      end
    end
    
    context 'given an admin_line_item with inventory_id of nil' do
      
      before{allow(admin_line).to receive(:inventory_id) {nil}}
      
      it 'should return nil' do
        admin_line.set_imprintable
        expect(admin_line.determine_imprintable_type).to be_nil
      end
    end
    
    context 'given an admin_line_item with inventory_id of 614 and an imprintable and an imprintable variant' do
    
      let!(:imprintable_variant) {create(:imprintable_variant, id: 22, imprintable_id: 72) }
      
      it 'should return imprintable_variant_type "Imprintable Variant"' do
        admin_line.set_imprintable
        expect(admin_line.determine_imprintable_type).to eq("Imprintable Variant")
      end
    end
  end

  describe '#is_taxable?' do
    
    let(:admin_item) { create (:admin_line_item) }
    let!(:admin_order) { create(:admin_order, is_tax_exempt: true) }
    
    context 'given an admin_line_item with an order_id of 1 that has a value of false for is_tax_exempt' do
      it 'should return true' do
        expect(admin_item.is_taxable?).to eq(true)
      end
    end
    context 'given an admin_line_item with an order_id of 1 that has a value of true for is_tax_exempt' do
      
      let!(:admin_order2) { create(:admin_order, is_tax_exempt: false) }
      
      before{ allow(admin_item).to receive(:order_id) {admin_order2.id} }
      it 'should return false' do
        expect(admin_item.is_taxable?).to eq(false)
      end
    end
    context 'given an admin_line_item with a nil order_id' do
      
      before { allow(admin_item).to receive(:order_id) {nil}}
      
      it 'should return true' do
        byebug
        expect(admin_item.is_taxable?).to eq(true)
      end
    end
  end

  describe '#get_url' do
    let!(:admin_line) { create(:admin_line_item) }
    let!(:imprintable) { create(:imprintable, id: 100) }

    context "given an admin_line_item with a valid imprintable" do
      it "should produce a url or 'www.test.com'" do
        admin_line.set_imprintable
        expect(admin_line.get_url).to eq("www.test.com")
      end
    end
    context 'given an admin_line_item with an invalid imprintable' do
      before{ allow(admin_line).to receive(:inventory_id) {200}}
      it 'should produce a url of nil' do
        admin_line.set_imprintable
        @imprintable = admin_line.get_imprintable
        expect(admin_line.get_url).to be_nil
      end
    end
  end
end
