require 'rails_helper'

RSpec.describe Admin::Customer, type: :model do
  context 'Associations' do
    it {is_expected.to have_many(:orders)}
  end 
end
