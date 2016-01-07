require 'rails_helper'

describe Admin::InventoryColor, type: :model do
  context 'Associations' do
    it { is_expected.to have_many(:inventories).with_foreign_key(:color_id) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:color) }
  end
end
