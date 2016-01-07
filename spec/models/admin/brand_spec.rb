require 'rails_helper'

describe Admin::Brand, type: :model do
  context 'Associations' do
    it { is_expected.to have_many(:inventories).with_foreign_key(:brand_id) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
