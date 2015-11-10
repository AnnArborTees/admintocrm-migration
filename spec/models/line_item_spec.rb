require 'rails_helper'

describe LineItem, type: :model do
  context 'Associations' do
    it {is_expected.to have_one(:order).through(:job)}
    it {is_expected.to belong_to(:job)}
    it {is_expected.to belong_to(:imprintable_variant)}
  end

  context 'Validations' do
    it {is_expected.to validate_presence_of(:job)}
  end
end
