require 'rails_helper'

describe Color, type: :model do
  context 'Association' do
    it {is_expected.to have_many(:imprintable_variants)}
  end
  
  context 'Validations' do
    it {is_expected.to validate_presence_of(:name)}
  end  
end
