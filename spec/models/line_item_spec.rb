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
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:unit_price) }
  end

  describe '::create_line_item_from_admin_line_and_job(admin_item, job)' do
    
    let!(:admin_item) { create (:admin_line_item) }
    let!(:admin_job) { create (:admin_job) }
    let!(:admin_order) { create (:admin_order) }
    let!(:old_job) { create(:job, name: "#{admin_job.title}", description: "#{admin_job.description}") }
    let!(:brand) { create(:brand, name: admin_item.inventory.brand.name) }
    let!(:imprintable) { create(:imprintable, 
                                brand_id: brand.id, style_catalog_no: admin_item.inventory.catalog_no) }

    context 'given an admin_line_item with job_id, and inventory_id yielding only an imprintable' do

      before { allow(admin_item).to receive(:job_id) {admin_job.id} }
      before { allow(admin_item).to receive(:order_id) {admin_order.id} }

      it "should create a line_item with line_itemable_id as job.id, line_itemable_type as 'Job'
          and imprintable_object_type as 'Imprintable'" do
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
        expect(line_item.line_itemable_id).to eq(job.id)
        expect(line_item.line_itemable_type).to eq("Job")
        expect(line_item.imprintable_price).to eq(0.00)
        expect(line_item.decoration_price).to eq(admin_item.unit_price)
        expect(line_item.imprintable_object_id).to eq(imprintable.id)
        expect(line_item.imprintable_object_type).to eq("Imprintable")
        expect(line_item.url).to eq(imprintable.supplier_link)
      end
    end

    context 'given an admin_line_item with a job_id and an inventory_id yieldings an imprintable and
             imprintablevariant' do

      let!(:size) { create(:size, display_value: admin_item.inventory.size.size) }
      let!(:color) { create(:color, name: admin_item.inventory.color.color) }
      let!(:imprintable_variant) { create(:imprintable_variant,
                                  imprintable_id: imprintable.id, color_id: color.id, size_id: size.id) }
      
      before { allow(admin_item).to receive(:job_id) {admin_job.id} }
      before { allow(admin_item).to receive(:order_id) {admin_order.id} }


      it 'should create a line_item with line_itemable_id as job.id, line_itemable_type as "Job" and
          imprintable_object_type as "ImprintableVariant"' do
        order = Order::create_from_admin_order(admin_order)
        job = Job::find_or_create_from_admin_job(order, admin_job)
        line_item = LineItem::create_from_admin_line_and_job(admin_item, job)
        expect(order.class).to eq(Order)
        expect(admin_item.class).to eq(Admin::LineItem)
        expect(line_item.class).to eq(LineItem)
        expect(line_item.name).to eq(admin_item.product)
        expect(line_item.quantity).to eq(admin_item.quantity)
        expect(line_item.taxable).to eq(admin_item.is_taxable?)
        expect(line_item.description).to eq(admin_item.description)
        expect(line_item.unit_price).to eq(admin_item.unit_price)
        expect(line_item.line_itemable_id).to eq(job.id)
        expect(line_item.line_itemable_type).to eq("Job")
        expect(line_item.imprintable_price).to eq(0.00)
        expect(line_item.decoration_price).to eq(admin_item.unit_price)
        expect(line_item.imprintable_object_id).to eq(imprintable_variant.id)
        expect(line_item.imprintable_object_type).to eq("Imprintable Variant")
        expect(line_item.url).to eq(imprintable.supplier_link)
      end
    end
  end
end
