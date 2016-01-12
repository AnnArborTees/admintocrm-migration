require 'rails_helper'

describe Admin::Payment, type: :model do
  
  context 'Associations' do
    it { is_expected.to belong_to(:order).with_foreign_key(:order_id) }
    it { is_expected.to belong_to(:admin).with_foreign_key(:user_id) }
    #it { is_expected.to have_many(:orders).with_foreign_key(:order_id) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:payment_method) }
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_presence_of(:order) }
  end
end
