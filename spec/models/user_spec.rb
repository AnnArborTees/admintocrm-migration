require 'rails_helper'

describe User, type: :model do
  context 'Associations' do
    it {is_expected.to have_many(:orders).with_foreign_key(:salesperson_id)}
  end 
  
  context 'Validations' do
    it {is_expected.to validate_presence_of(:email) }
  end 
  
  describe '::find_or_create_from_admin_order(admin_order)' do 
    
    let(:admin_order) { create(:admin_order) }
    let(:admin_user) { admin_order.admin } 

    context 'when order has admin with complete data' do  
      it 'Creates a user with the attributes from admin_order.admin' do
        new_user =  User.find_or_create_from_admin_order(admin_order)
        
        expect(new_user.class).to eq(User)
        expect(new_user.persisted?).to be_truthy
        expect(new_user.email).to eq(admin_user.email)
        expect(new_user.first_name).to eq(admin_user.first_name)
        expect(new_user.last_name).to eq(admin_user.last_name)      
      end
    end

    context 'when order does not have admin with complete data' do 
      
      before { allow(admin_user).to receive(:email) { nil } }

      it 'does not create a new user' do
        new_user =  User.find_or_create_from_admin_order(admin_order)
        expect(new_user).to be_nil
      end
    end
  end
end
