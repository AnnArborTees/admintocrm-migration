require 'rails_helper'

RSpec.describe Admin::User, type: :model do
  context 'Associations' do
    it {is_expected.to have_many(:orders)}
  end

  context 'Associations' do
    it {is_expected.to validate_presence_of(:first_name)}
    it {is_expected.to validate_presence_of(:last_name)}
#    it {is_expected.to validate_presence_of(:email)}
 #   it {is_expected.to validate_presence_of(:salesperson)}
  end

end
