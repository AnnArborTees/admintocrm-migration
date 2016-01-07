require 'rails_helper'

describe Order, type: :model do
  context 'Associations' do
    it { is_expected.to have_many(:shipments) } 
    it { is_expected.to have_many(:line_items).through(:jobs).with_foreign_key(:line_itemable_id) } 
    it { is_expected.to have_many(:jobs) }
    it { is_expected.to have_many(:payments).with_foreign_key(:order_id) }
    it { is_expected.to belong_to(:store) }
    it { is_expected.to belong_to(:salesperson) }
    #it { is_expected.to belong_to(:payment).with_foreign_key(:order_id) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:firstname) }
    it { is_expected.to validate_presence_of(:lastname) }
    it { is_expected.to validate_presence_of(:in_hand_by) }
    it { is_expected.to validate_presence_of(:delivery_method) }
    it { is_expected.to validate_presence_of(:store) }
    it { is_expected.to validate_presence_of(:salesperson) }
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "::get_terms_from_admin_order(admin_order)" do
    
    let(:admin_order) { create(:admin_order) }
    let(:admin_terms) { admin_order }
    
    context "admin_order terms are '5050'" do
      it "sets order terms as 'Half down on purchase'" do
        terms = Order::get_terms_from_admin_order(admin_order) 

        expect(terms).to eq("Half down on purchase")
      end
    end

    context "admin_order terms are 'invoice'" do
      before{ allow(admin_terms).to receive(:terms) {"invoice"} }

      it "sets order terms as 'Net 30'" do
        terms = Order::get_terms_from_admin_order(admin_order)
        expect(terms).to eq("Net 30")
      end
    end

    context "admin_order terms are 'paid_on_pickup'" do
      
      before{
        allow(admin_terms).to receive(:terms) {"paid_on_pickup"}
      }

      it "sets order terms as 'Paid in full on pick up'" do
        terms = Order::get_terms_from_admin_order(admin_order)
        expect(terms).to eq("Paid in full on pick up")
      end
    end
    
    context "admin_order terms are 'paid_on_purchase'" do
      
      before{
        allow(admin_terms).to receive(:terms) {"paid_on_purchase"}
      }

      it "sets order terms as 'Paid in full on purchase'" do
        terms = Order::get_terms_from_admin_order(admin_order)
        expect(terms).to eq("Paid in full on purchase")
      end
    end
    
    context "admin_order terms are nil" do
      
      before{
        allow(admin_terms).to receive(:terms) {nil}
      }

      it "sets order terms as 'Paid in full on purchase'" do
        terms = Order::get_terms_from_admin_order(admin_order)
        expect(terms).to eq("Paid in full on purchase")
      end
    end
  end

  describe "::get_ship_method_from_admin_order(admin_order)" do
    
    let(:admin_order) { create(:admin_order) }
    let(:admin_ship_method) { admin_order }

    context "admin_order ship_method is 'Pick Up (Ypsilanti)'" do
      it "sets order delivery_method to 'Pick up in Ypsilanti" do
        ship = Order::get_ship_method_from_admin_order(admin_order)
        expect(ship).to eq("Pick up in Ypsilanti") 
      end
    end

    context "admin_order ship_method is 'Pick Up'" do
      
      before{ allow(admin_ship_method).to receive(:ship_method) {"Pick Up"} }
      it "sets order delivery_method to 'Pick up in Ann Arbor" do
        ship = Order::get_ship_method_from_admin_order(admin_order)
        expect(ship).to eq("Pick up in Ann Arbor")
      end
    end

    context "admin_order ship_method is anything else" do
      
      before{ allow(admin_ship_method).to receive(:ship_method) {"AATC Delivery"} }
      it "sets order delivery_method to 'Ship to one location'" do
        ship = Order::get_ship_method_from_admin_order(admin_order)
        expect(ship).to eq("Ship to one location")
      end
    end
  end

  describe "::create_from_admin_order(admin_order)" do 
    context "given an admin_order with a customer and an admin" do
        
      let(:admin_order) { create(:admin_order) } 
      context 'and an order with that id does not exist' do 
        it 'creates and returns a valid order and finds or creates the salesperson' do 
          o = Order::create_from_admin_order(admin_order)
          expect(o.valid?).to be_truthy
          expect(o.persisted?).to be_truthy
          expect(o.class).to eq(Order)
          expect(o.id).to eq(admin_order.id)
          expect(o.name).to eq(admin_order.title)
          expect(o.firstname).to eq(admin_order.customer.first_name)
          expect(o.lastname).to eq(admin_order.customer.last_name)
          expect(o.email).to eq(admin_order.customer.email)
          expect(o.in_hand_by).to eq(admin_order.delivery_deadline)
          expect(o.terms).to eq(Order::get_terms_from_admin_order(admin_order))
          expect(o.delivery_method).to eq(Order::get_ship_method_from_admin_order(admin_order))
          expect(o.store_id).to eq(Store::find_or_create_from_admin_order(admin_order).id)
          expect(o.salesperson_id).to eq(User::find_or_create_from_admin_order(admin_order).id)

        end
      end
        
      context 'and order with that id does exist' do 

        let(:admin_order) { create(:admin_order, title: 'some other junk') }
        let(:order) { create(:order, id: admin_order.id) }
        it 'updates order and finds or creates the salesperson' do
          o = Order::create_from_admin_order(admin_order)
          expect(o.name).to eq(admin_order.title)
          expect(o.id).to eq(admin_order.id)
        end
      end
    end
  end

  describe "#create_shipment_from_admin_order(admin_order)" do
      
    let(:admin_order) { create(:admin_order) }
    let(:order) { create(:order) }
    context "admin_order's ship_method is not a 'Pick Up'" do
        
      before{ allow(admin_order).to receive(:ship_method) {"USPS"} }
      it 'initializes and inserts into shipments a shipment from admin_order information' do
        order.create_shipment_from_admin_order(admin_order)
        expect(order.shipments).to_not be_empty
        expect(order.shipments.first.address_1).to eq(admin_order.delivery_address_1)
      end
    end

    context "admin_order's ship_method is a 'Pick Up'" do
      it 'does not initialize or insert a shipment into shipments from admin_order information' do
        order.create_shipment_from_admin_order(admin_order)
        expect(order.shipments).to be_empty
      end
    end
  end
  
  describe "#create_job_from_admin_job(admin_job)" do

    let(:admin_job) { create(:admin_job) }
    let(:order) { create(:order) }
    context "admin_job's title is valid" do
      it 'initializes and inserts into jobs a job with admin_job title' do
        order.create_job_from_admin_job(admin_job)
        expect(order.jobs).to_not be_empty
        expect(order.jobs.first.name).to eq(admin_job.title)
      end
    end

    context "admin_job has an invalid title" do

      before { allow(admin_job).to receive(:title) {nil} }
      it 'does not initialize or insert a job into jobs from admin_job title' do
        order.create_job_from_admin_job(admin_job)
        expect(order.jobs).to be_empty
      end
    end
  end
end
