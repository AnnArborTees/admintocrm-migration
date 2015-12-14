require 'rails_helper'

describe LineItem, type: :model do
  context 'Associations' do
    it { is_expected.to have_one(:order).through(:job)}
    it { is_expected.to belong_to(:job)}
    it { is_expected.to belong_to(:imprintable_variant)}
    it { is_expected.to belong_to(:line_itemable) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:job)}
    it { is_expected.to validate_presence_of(:line_itemable) }
  end

  describe '#create_line_item_from_admin_line_item(admin_item)' do
    context 'given an admin_line_item with valid data' do
      it 'should create a line_item' do
        byebug
      end
    end
  end
end
