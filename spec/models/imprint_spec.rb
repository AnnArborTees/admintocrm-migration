require 'rails_helper'

describe Imprint, type: :model do
  context 'Associations' do
    it{is_expected.to belong_to(:job)}
  end

  context 'Validations' do
    it{is_expected.to validate_presence_of(:job)}
  end
end
