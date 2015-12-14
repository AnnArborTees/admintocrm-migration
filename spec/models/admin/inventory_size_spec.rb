require 'rails_helper'

describe Admin::InventorySize, type: :model do
  context 'Associations' do
    it { is_expected.to have_many(:inventories).with_foreign_key(:size_id) }
  end 
end
