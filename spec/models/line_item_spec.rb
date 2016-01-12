require 'rails_helper'

describe LineItem, type: :model do
  context 'Associations' do
    it { is_expected.to have_one(:order).through(:job)}
    it { is_expected.to belong_to(:job)}
    it { is_expected.to belong_to(:imprintable_variant)}
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:job)}
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:quantity) }
    #it { is_expected.to validate_presence_of(:taxable) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:unit_price) }
  end

  describe '::create_line_item_from_admin_line_and_job(admin_item, job)' do
    
    let!(:admin_item) { create (:admin_line_item) }
    let!(:admin_job) { create (:admin_job) }
    let!(:admin_order) { create (:admin_order) }
    let!(:old_job) { create(:job, name: "#{admin_job.title}", description: "#{admin_job.description}") }

    context 'given an admin_line_item with valid data and a job with valid data' do

      before { allow(admin_item).to receive(:job_id) {admin_job.id} }

      it 'should create a line_item with line_itemable_id as job.id, and line_itemable_type as "Job"' do
        order = Order::create_from_admin_order(admin_order)
        job = Job::find_or_create_from_admin_job(order,admin_job)
        line_item = LineItem::create_from_admin_line_and_job(admin_item, job)
        expect(order.class).to eq(Order)
        expect(admin_item.class).to eq(Admin::LineItem)
        expect(line_item.class).to eq(LineItem)
        expect(line_item.name).to eq(admin_item.product)
        expect(line_item.quantity).to eq(admin_item.quantity)
        expect(line_item.taxable).to eq(admin_item.is_taxable?)
        expect(line_item.description).to eq(admin_item.description)
        expect(line_item.unit_price).to eq(admin_item.unit_price)
        expect(line_item.line_itemable_id).to eq(job.jobbable_id)
        expect(line_item.line_itemable_type).to eq("Job")
        expect(line_item.imprintable_price).to eq(admin_item.determine_imprintable_price)
        expect(line_item.decoration_price).to eq(admin_item.determine_decoration_price)
        expect(line_item.imprintable_object_id).to eq(admin_item.determine_imprintable_id)
        expect(line_item.imprintable_object_type).to eq(admin_item.determine_imprintable_type)
        expect(line_item.url).to eq(admin_item.get_url)
      end
    end
    
    context 'given an admin_line_item with valid data and a job with a nil id' do
      
      before { allow(admin_item).to receive(:job_id) {nil} }
      before { allow(admin_order).to receive(:id) {2} } 
      
      it 'should create a line_item with line_itemable_id as admin_item.order_id and line_itemable_type as "Order"' do
        order = Order::create_from_admin_order(admin_order)
        job = Job::find_or_create_from_admin_job(order, admin_job)
        line_item = LineItem::create_from_admin_line_and_job(admin_item, job)
        expect(admin_item.job_id).to be_nil
        expect(line_item.line_itemable_type).to eq("Order")
        expect(line_item.line_itemable_id).to eq(order.id)
      end
    end
  end

  describe '#determine_subtotal' do
    let(:line_item) { create(:line_item, quantity: 20, decoration_price: 2.99) }
    context 'given a line_item with quantity 10 and decoration_price of 2.99' do
      it 'should return 59.8' do
        subtotal = line_item.determine_subtotal
        expect(subtotal).to eq(59.8)
      end
    end
  end

  describe '#determine_tax' do
    let(:line_item) { create(:line_item, quantity: 20, decoration_price: 2.99, taxable: true) }
    context 'given a line_item with quantity 10 and decoration_price of 2.99 and taxable true' do
      it 'should return a tax value of 3.59' do
        subtotal = line_item.determine_subtotal
        tax = line_item.determine_tax(subtotal)
        expect(tax).to eq(3.59) 
      end
    end
    context 'given a line_item with quantity 20, decoration_price 2.99 and taxable false' do
      before{ allow(line_item).to receive(:taxable)  {false}}
      it 'should return a tax value of 0' do
        tax = line_item.determine_tax(line_item.taxable)
        expect(tax).to eq(0)
      end
    end
  end
end
