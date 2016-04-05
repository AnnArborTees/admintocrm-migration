class LineItem < ActiveRecord::Base
  has_one :order, through: :job, foreign_key: :jobbable_id
  belongs_to :job
  belongs_to :imprintable_variant, foreign_key: :imprintable_object_id

  validates :job, presence: true
  validates :name, presence: true
  validates :quantity, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  validates :decoration_price, presence: true

  def self.create_from_admin_line_and_job(admin_item, job)
    line = self.find_or_initialize_by(self.params_from_admin_item_and_job(admin_item, job))

    if line.new_record?
      line.save
    end

    return line
  end

  def self.params_from_admin_item_and_job(admin_item, job)
    imprintable = Imprintable::find_by_admin_inventory_id(admin_item.inventory_id)
    variant =
      ImprintableVariant::find_or_create_by_admin_inventory_id(admin_item.inventory_id) unless imprintable.nil?
    {
      name: admin_item.product,
      quantity: admin_item.quantity,
      taxable: admin_item.is_taxable?,
      description: admin_item.description,
      unit_price: admin_item.unit_price,
      decoration_price: admin_item.unit_price,
      imprintable_price: 0.00,
      job_id: job.id,
      url: imprintable.nil? ? nil : imprintable.supplier_link,
      imprintable_object_id: variant.nil? ?
        (imprintable.nil? ? nil : imprintable.id) : variant.id,
      imprintable_object_type: variant.nil? ?
        (imprintable.nil? ? nil : "Imprintable") : "Imprintable Variant"
    }
  end
end
