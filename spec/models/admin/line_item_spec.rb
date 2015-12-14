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
    context 'given an admin_line_item with inventory_id of 614 ' do
      it 'should return imprintable_id of 387' do
      end
    end
    context 'given an admin_line_item with inventory_id of ' do
      it '' do
      end
    end
    context '' do
      it '' do
      end
    end
  end
end
