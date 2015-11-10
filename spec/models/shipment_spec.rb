require 'rails_helper'

describe Shipment, type: :model do
  context 'Associations' do
    it { is_expected.to belong_to(:shipping_method) }
    it { is_expected.to belong_to(:shippable) }
  end

  context 'Validations' do
    it {is_expected.to validate_presence_of(:shippable) }
    it {is_expected.to validate_presence_of(:shipping_method) }
    it {is_expected.to validate_presence_of(:name) }
    it {is_expected.to validate_presence_of(:address_1) }
    it {is_expected.to validate_presence_of(:city) }
    it {is_expected.to validate_presence_of(:state) }
    it {is_expected.to validate_presence_of(:zipcode) }
  end

  describe "::new_shipment_from_admin_order(admin_order)" do

    let(:admin_order) { create(:admin_order) }
    let(:new_ship) { Shipment::new_shipment_from_admin_order(admin_order) }
   
    context 'admin_order has a ship_method other than Pick Up or Pick Up (Ypsilanti)' do
      before { allow(admin_order).to receive(:ship_method) {'USPS'} }

      it 'initializes a shipment with shipping_method, company, name, address_1, address_2, address_3,  
        city, state, and zipcode' do
        expect(new_ship.class).to eq(Shipment)
        byebug
        expect(new_ship.name).to eq("#{admin_order.customer.first_name} #{admin_order.customer.last_name}")
        expect(new_ship.address_1).to eq(admin_order.delivery_address_1)
        expect(new_ship.address_2).to eq(admin_order.delivery_address_2)
        expect(new_ship.address_3).to eq(admin_order.delivery_address_3)
        expect(new_ship.company).to eq(admin_order.delivery_company)
        expect(new_ship.city).to eq(admin_order.delivery_city)
        expect(new_ship.state).to eq(admin_order.delivery_state)
        expect(new_ship.zipcode).to eq(admin_order.delivery_zipcode)
        expect(new_ship.shipping_method_id).to eq(ShippingMethod.find_or_create_from_admin_order(admin_order).id)
      end
    end

    context 'admin_order has ship_method of Pick Up or Pick Up (Ypsilanti)' do
      it 'does not create a shipment'do
        expect(new_ship).to be_nil
      end
    end  
  end
end
