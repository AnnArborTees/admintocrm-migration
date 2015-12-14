class Admin::LineItem < ActiveRecord::Base
  belongs_to :inventory, class_name: "Admin::Inventory", foreign_key: :inventory_id
  belongs_to :job, class_name: "Admin::Job", foreign_key: :job_id
  has_one :order, class_name: "Admin::Order", through: :job, foreign_key: :custom_order_id

  validates :inventory, presence: true
  validates :order_id, presence: true
  validates :product, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  validates :quantity, presence: true
  validates :taxable, presence: true
  validates :job_id, presence: true 

  def set_imprintable
    if self.inventory_id.nil?
      return nil
    end

    @imp = Imprintable::find_by_admin_inventory_id(self.inventory_id)
    @var = ImprintableVariant::find_by_admin_inventory_id(self.inventory_id)
  end

  def determine_imprintable_id
    if @imp
      if @var
        return @var.id
      else
        return @imp.id
      end
    else
      return nil 
    end
  end 

  def determine_imprintable_type
    if @imp.nil?
      return nil
    elsif @var.nil?
      return "Imprintable"
    else
      return "Imprintable Variant"
    end
  end
end
