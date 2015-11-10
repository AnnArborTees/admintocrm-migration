require 'rails_helper'

describe ShippingMethod, type: :model do
  context 'Associations' do
    it { is_expected.to have_many(:shipments) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "::find_or_create_from_admin_order(admin_order)" do

   let(:admin_order) { create(:admin_order) } 

    context 'given a valid admin_order with a ship_method' do
      it 'creates or finds a shipping_method from the admin_order' do
        s_method = ShippingMethod::find_or_create_from_admin_order(admin_order)

        expect(s_method.class).to eq(ShippingMethod)
        expect(s_method.persisted?).to be_truthy
        expect(s_method.name).to eq(admin_order.ship_method)
      end
    end
  end
end

