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

  describe '#is_taxable?' do
    
    let(:admin_item) { create (:admin_line_item) }
    let(:admin_order) { create(:admin_order, id: admin_item.order_id, is_tax_exempt: true) }
    
    context 'given an admin_line_item with an order_id matching an Admin::Order 
             that has a value of true for is_tax_exempt' do
      
      it 'should return false' do
        admin_order
        expect(admin_item.is_taxable?).to eq(false)
      end
    end
    context 'given an admin_line_item with an order_id matching an Admin::Order
             that has a value of false for is_tax_exempt' do
      
      let!(:admin_order2) { create(:admin_order, is_tax_exempt: false) }
      
      before{ allow(admin_item).to receive(:order_id) {admin_order2.id} }
      it 'should return true' do
        expect(admin_item.is_taxable?).to eq(true)
      end
    end
  end
end
