require 'rails_helper'

describe Admin::InventoryLine, type: :model do
  context 'Associations' do
    it { is_expected.to have_many(:inventories) }
    it { is_expected.to belong_to(:brand).with_foreign_key(:brand_id) }
  end 

  context 'Validations' do
    it { is_expected.to validate_presence_of(:catalog_number) }
    it { is_expected.to validate_presence_of(:brand) }
  end
end
