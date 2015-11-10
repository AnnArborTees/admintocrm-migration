require 'rails_helper'

describe Store, type: :model do
  
  context 'Associations' do
    it { is_expected.to have_many(:orders).with_foreign_key(:store_id)}
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe '::determine_store_name(admin_order)', current: true do 
    context "ship_method is 'Pick Up (Ypsilanti)'" do 
      
      let(:admin_order) { create(:admin_order, ship_method: 'Pick Up In Ypsi') } 
      
      it "returns 'Ypsilanti T-shirt Company'" do 
        expect(Store::determine_store_name(admin_order)).to eq('Ypsilanti T-shirt Company')
      end
    end

    context "ship_method is anything else" do 
      let(:admin_order) { create(:admin_order, ship_method: nil) } 
      
      it "returns 'Ann Arbor T-shirt Company'" do 
        expect(Store::determine_store_name(admin_order)).to eq('Ann Arbor T-shirt Company')
      end
    end
  end

  describe '::find_or_create_from_admin_order(admin_order)' do

    let(:admin_order) { create(:admin_order) }
    let(:admin_store) { admin_order }

    context 'when order has admin with complete data' do
      
      it 'creates a valid, persisted store' do
        new_store = Store.find_or_create_from_admin_order(admin_order)
        expect(new_store.class).to eq(Store)
        expect(new_store.persisted?).to be_truthy
      end

      context 'when ship_method is Pick Up (Ypsilanti)' do
        
        it 'creates a store with name Ypsilanti T-shirt Company' do
          new_store = Store.find_or_create_from_admin_order(admin_order)
          expect(new_store.name).to eq("Ypsilanti T-shirt Company")
        end
      end

      context 'when ship_method is anything else' do
        before { allow(admin_store).to receive(:ship_method) {"UPS" } }  
        it 'creates a store with name Ann Arbor T-shirt Company' do
          new_store = Store.find_or_create_from_admin_order(admin_order)
          expect(new_store.name).to eq("Ann Arbor T-shirt Company")
        end
      end
    end
  end
end
