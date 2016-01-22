require 'rails_helper'

describe Admin::Order, type: :model do
  context 'Associations' do
    it { is_expected.to belong_to(:customer).with_foreign_key(:customer_id) }
    it { is_expected.to belong_to(:admin).with_foreign_key(:administrator_id) }
    it { is_expected.to have_many(:jobs).with_foreign_key(:custom_order_id) }
    it { is_expected.to have_many(:payments).with_foreign_key(:order_id) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:customer_id) }
    it { is_expected.to validate_presence_of(:administrator_id) }
    it { is_expected.to validate_presence_of(:type) }
  end
end
