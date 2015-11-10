require 'rails_helper'

RSpec.describe Admin::Admin, type: :model do
  context 'Associations' do
    it {is_expected.to have_many(:orders)}
  end

  context 'Validations' do
    it {is_expected.to validate_presence_of(:salesperson)}
  end
end
