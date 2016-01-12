require 'rails_helper'

describe Discount, type: :model do
  context 'Associations' do
    it { is_expected.to belong_to(:order).with_foreign_key(:order_id) }
    it { is_expected.to belong_to(:salesperson).with_foreign_key(:salesperson_id) }
  end
  context 'Validations' do
    it { is_expected.to validate_presence_of(:refunded) }
    it { is_expected.to validate_presence_of(:order) }
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_presence_of(:salesperson) }
    it { is_expected.to validate_presence_of(:t_description) }
    it { is_expected.to validate_presence_of(:store) }
    it { is_expected.to validate_presence_of(:payment_method) }
  end

  describe '::find_by_admin_payment(admin_payment)' do 
    
    let(:admin_payment) { create(:admin_payment, amount: -200) }

    context 'given an admin_payment with a negative amount' do
      it 'creates a discount with data from admin_payment' do
        discount = Discount::find_by_admin_payment(admin_payment)
        expect(discount.t_description).to eq(Payment::get_description(admin_payment))
        expect(discount.store_id).to eq(Store::find_or_create_from_admin_order(admin_payment.order).id)
        expect(discount.salesperson_id).to eq(User::find_or_create_from_admin_order(admin_payment.order).id)
        expect(discount.payment_method).to eq(Payment::determine_payment_method(admin_payment))
        expect(discount.amount).to eq(-200)
      end
    end
  end
end
