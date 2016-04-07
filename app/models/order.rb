class Order < ActiveRecord::Base
  has_many :shipments, as: :shippable
  has_many :line_items, through: :jobs, foreign_key: :line_itemable_id
  has_many :jobs, foreign_key: :jobbable_id
  has_many :payments, foreign_key: :order_id
  has_many :admin_proofs, foreign_key: :order_id
  belongs_to :store, foreign_key: :store_id
  belongs_to :salesperson, class_name: "User", foreign_key: :salesperson_id

  validates :email, presence: true
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :in_hand_by, presence: true
  validates :terms, presence: true
  validates :delivery_method, presence: true
  validates :store, presence: true
  validates :salesperson, presence: true
  validates :name, presence: true

  after_initialize do
    next unless respond_to?(:customer_key)
    while customer_key.blank? ||
      Order.where(customer_key: customer_key).where.not(id: id).exists?
      self.customer_key = rand(36**6).to_s(36).upcase
    end
  end

  # def self.create_from_admin_order_alternative(admin_order)
  #   order = Order.find_by(id: crm_order_id_from_admin_order(admin_order))
  #
  #   if order
  #     order.update(self.params_from_admin_order(admin_order))
  #   else
  #     self.create(self.params_from_admin_order(admin_order))
  #   end
  # end

  def self.create_from_admin_order(admin_order)
    order = self.find_or_initialize_by(id: admin_order.crm_order_id)
    order.name = admin_order.title
    order.firstname = admin_order.customer.first_name
    order.lastname = (admin_order.customer.last_name.blank? ? '(Not Provided' : admin_order.customer.last_name)
    order.email = admin_order.customer.email
    order.in_hand_by = (admin_order.delivery_deadline.blank? ? admin_order.created_at : admin_order.delivery_deadline)
    order.terms = self.get_terms_from_admin_order(admin_order)
    order.delivery_method = self.get_ship_method_from_admin_order(admin_order)
    order.store_id = Store.find_or_create_from_admin_order(admin_order).id
    order.salesperson_id = User.find_or_create_from_admin_order(admin_order).id
    order.imported_from_admin = true
    order.artwork_state = :in_production
    order.invoice_state = :approved
    order.production_state = :complete
    order.notification_state = :picked_up
    order.phone_number = admin_order.crm_phone_number
    order.shipping_price = admin_order.shipping || 0.0
    order.save!
    return order
  end
  #
  # def self.params_from_admin_order(admin_order)
  #   {
  #     id: admin_order.id,
  #     name: admin_order.title,
  #     firstname: admin_order.customer.first_name,
  #     lastname: admin_order.customer.last_name,
  #     email: admin_order.customer.email,
  #     in_hand_by: admin_order.delivery_deadline,
  #     terms: self.get_terms_from_admin_order(admin_order),
  #     delivery_method: self.get_ship_method_from_admin_order(admin_order),
  #     store_id: Store.find_or_create_from_admin_order(admin_order).id,
  #     salesperson_id: User.find_or_create_from_admin_order(admin_order).id,
  #     imported_from_admin: true,
  #     artwork_state: :in_production,
  #     invoice_state: :approved,
  #     production_state: :complete,
  #     notification_state: :picked_up,
  #     phone_number: admin_order.crm_phone_number
  #   }
  # end

  def self.get_terms_from_admin_order(admin_order)
    case admin_order.terms
    when "5050"
      return "Half down on purchase"
    when "invoice"
      return "Net 30"
    when "paid_on_pickup"
      return "Paid in full on pick up"
    else
      return "Paid in full on purchase"
    end
  end

  def self.get_ship_method_from_admin_order(admin_order)
    case admin_order.ship_method
    when "Pick Up (Ypsilanti)"
      return "Pick up in Ypsilanti"
    when "Pick Up"
      return "Pick up in Ann Arbor"
    else
      return "Ship to one location"
    end
  end

  def create_shipment_from_admin_order(admin_order)
    shipment = Shipment.new_shipment_from_admin_order(admin_order)
    shipments << shipment unless shipment.nil?
  end

  def create_job_from_admin_job(admin_job)
    job = Job::find_or_create_from_admin_job(self, admin_job)
    jobs << job unless job.nil?
    return job
  end

  def create_line_item_from_admin_line_item(admin_line, job)
    line_item = LineItem::create_from_admin_line_and_job(admin_line, job)
    line_items << line_item unless line_item.nil?
    return line_item
  end

  def recalculate_totals!
    recalculate_totals
    self.save!
  end

  def recalculate_totals
    recalculate_subtotal
    recalculate_taxable_total
    recalculate_payment_total
    self.discount_total = 0.0
  end

  def recalculate_subtotal
    self.subtotal = line_items.reload.map { |li| li.total_price.to_f }.reduce(0, :+)
  end

  def recalculate_payment_total
    self.payment_total = payments.reload.map { |p| p.amount.to_f }.reduce(0, :+)
  end

  def recalculate_taxable_total
    (self.taxable_total = 0) if tax_exempt?
    self.taxable_total = line_items.reload.taxable.map { |li| li.total_price.to_f }.reduce(0, :+)
  end

  def create_payment!(admin_order)
    if admin_order.payments.empty?
      Payment.create!(
        order_id: self.id,
        salesperson_id: self.salesperson_id,
        store_id: self.store_id,
        amount: self.balance,
        payment_method: 1
      )
    else
      Payment.create!(
        order_id: self.id,
        salesperson_id: self.salesperson_id,
        store_id: self.store_id,
        amount: self.balance,
        payment_method: Payment::determine_payment_method(admin_order.payments.first)
      )
    end
    recalculate_totals!
  end

  def balance
    self.subtotal + self.tax + self.shipping_price
  end

  def tax
    taxable_total * 0.06
  end

  def create_shipment!(admin_order)
    return nil if admin_order.ship_method.downcase.include? "pick up"

    Shipment.create(
      name: "#{admin_order.customer.first_name} #{admin_order.customer.last_name}",
      address_1: admin_order.delivery_address_1,
      address_2: admin_order.delivery_address_2,
      address_3: admin_order.delivery_address_3,
      company: admin_order.delivery_company,
      city: admin_order.delivery_city,
      state: admin_order.delivery_state,
      zipcode: admin_order.delivery_zipcode,
      shippable_id: self.id,
      shippable_type: "Order",
      shipping_method_id: ShippingMethod::find_from_admin_order(admin_order)
    )
  end

  def update_all_timestamps(admin_order)
    update_columns(created_at: admin_order.created_at, updated_at: admin_order.created_at)
    payments.update_all(created_at: admin_order.created_at, updated_at: admin_order.created_at)
    shipments.update_all(created_at: admin_order.created_at, updated_at: admin_order.created_at)
    line_items.update_all(created_at: admin_order.created_at, updated_at: admin_order.created_at)
  end

end
