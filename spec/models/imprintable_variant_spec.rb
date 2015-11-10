require 'rails_helper'

describe ImprintableVariant, type: :model do
  context 'Associations' do
    it {is_expected.to belong_to(:imprintable)}
    it {is_expected.to have_many(:line_items)}
    it {is_expected.to belong_to(:color)}
    it {is_expected.to belong_to(:size)}
    it {is_expected.to have_one(:brand).through(:imprintable)}
    end

  context 'Validations' do
    #imprintable
    it{is_expected.to validate_presence_of(:imprintable)}
    #color
    it{is_expected.to validate_presence_of(:color)}
    #size
    it{is_expected.to validate_presence_of(:size)}
  end
end
