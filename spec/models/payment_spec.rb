require 'rails_helper'

describe Payment, type: :model do
  context 'Associations' do
    it { is_expected.to belong_to(:order).with_foreign_key(:order_id) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:payment_method) }
    it { is_expected.to validate_presence_of(:t_description) }
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_presence_of(:store) }
    it { is_expected.to validate_presence_of(:salesperson) }
    it { is_expected.to validate_presence_of(:order) }
  end

  describe '::find_by_admin_payment(admin_payment)' do
   
    let(:admin_payment) { create(:admin_payment, payment_method: "Cash", amount: 300 ) }

    context 'given an admin_payment with matching order_id and payment_method "Cash" and amount "300"' do
      it 'should return a payment with payment_method "Cash" and amount "300"' do
        payment = Payment::find_by_admin_payment(admin_payment)
        expect(payment.class).to be(Payment)
        expect(payment.t_description).to eq(Payment::get_description(admin_payment))
        expect(payment.store_id).to eq(Store::find_or_create_from_admin_order(admin_payment.order).id)
        expect(payment.salesperson_id).to eq(User::find_or_create_from_admin_order(admin_payment.order).id)
        expect(payment.payment_method).to eq(Payment::determine_payment_method(admin_payment))
        expect(payment.amount).to eq(300)
      end
    end
  end

  #don't know if this is necessary but put it in here anyways
  describe '::get_description' do
    
    let(:admin_payment) { create(:admin_payment) }
    
    context 'given an admin_payment with order title "Test" and payment first and last name "Stefan Gale"' do 
      before { allow(admin_payment.order).to receive(:title) {"Test"} }
      it 'should return  "Test for Stefan Gale"' do
        expect(Payment::get_description(admin_payment)).to eq("Test for #{admin_payment.order.customer.first_name} #{admin_payment.order.customer.last_name}") 
      end
    end
  end

  describe '::determine_payment_method(admin_payment)' do
    
    let(:admin_payment) { create(:admin_payment) }
    
    context 'given an admin_payment with payment_method "Cash"' do
      it 'should return "1"' do
        expect(Payment::determine_payment_method(admin_payment)).to eq(1)
      end
    end
    
    context 'given an admin_payment with payment_method "Credit Card"' do
      
      before { allow(admin_payment).to receive (:payment_method) {"Credit Card"} }
      
      it 'should return "2"' do
        expect(Payment::determine_payment_method(admin_payment)).to eq(2)
      end
    end
    
    context 'given an admin_payment with payment_method "Swiped Credit Card"' do
      
      before { allow(admin_payment).to receive (:payment_method) {"Swiped Credit Card"} }
      
      it 'should return "2"' do
        expect(Payment::determine_payment_method(admin_payment)).to eq(2)
      end
    end
    
    context 'given an admin_payment with payment_method "Check"' do
      
      before { allow(admin_payment).to receive (:payment_method) {"Check"} }
      
      it 'should return "3"' do
        expect(Payment::determine_payment_method(admin_payment)).to eq(3)
      end
    end
    
    context 'given an admin_payment with payment_method "Paypal"' do
      
      before { allow(admin_payment).to receive (:payment_method) {"Paypal"} }
      
      it 'should return "4"' do
        expect(Payment::determine_payment_method(admin_payment)).to eq(4)
      end
    end
    
    context 'given an admin_payment with payment_method "Wire Transfer"' do
      
      before { allow(admin_payment).to receive (:payment_method) {"Wire Transfer"} }
      
      it 'should return "7"' do
        expect(Payment::determine_payment_method(admin_payment)).to eq(7)
      end
    end
  end
end
