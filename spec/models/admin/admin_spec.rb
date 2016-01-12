require 'rails_helper'

RSpec.describe Admin::Admin, type: :model do
  context 'Associations' do
    it { is_expected.to have_many(:orders).with_foreign_key(:administrator_id) }
    it { is_expected.to have_many(:payments).with_foreign_key(:user_id) }
  end

  context 'Validations' do
    it {is_expected.to validate_presence_of(:salesperson)}
  end
end
