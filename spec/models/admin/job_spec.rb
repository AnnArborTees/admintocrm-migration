require 'rails_helper'

describe Admin::Job, type: :model do
  context 'Associations' do
    it { is_expected.to belong_to(:order).with_foreign_key(:custom_order_id) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
  end
end
