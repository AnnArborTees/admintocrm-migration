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
    order.valid? ? order.imported_from_admin = false : order.imported_from_admin = true
    order.name = admin_order.title
    order.firstname = admin_order.customer.first_name
    order.lastname = admin_order.customer.last_name
    order.email = admin_order.customer.email
    order.in_hand_by = admin_order.delivery_deadline
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
    order.save
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

end
