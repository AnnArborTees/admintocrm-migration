class Admin::Order < ActiveRecord::Base
  establish_connection Admin::database_name

  default_scope { where(type: "customOrder").
    where.not(status: %w(Cancelled Garment\ Hold Incomplete Pending quoted)) }
  self.inheritance_column = :_type_disabled

  belongs_to :customer, class_name: 'Admin::Customer', foreign_key: :customer_id
  belongs_to :admin, class_name: 'Admin::Admin', foreign_key: :administrator_id
  has_many :payments, class_name: "Admin::Payment", foreign_key: :order_id
  has_many :jobs, class_name: "Admin::Job", foreign_key: :custom_order_id
  has_many :line_items, class_name: "Admin::LineItem", through: :jobs, foreign_key: :order_id
  has_many :order_line_items, -> { where(job_id: 0)},  class_name: "Admin::LineItem", foreign_key: :order_id

  validates :customer_id, presence: true
  validates :administrator_id, presence: true
  validates :type, presence: true


  def crm_order_id
    return id if (id < 60000)
    id % 60000 + 65000
  end

  def crm_phone_number(options = {})
    return '000-000-0000'  if customer.phone_number.blank?
    options = options.symbolize_keys

    parse_float(customer.phone_number, true) if options.delete(:raise)
    ERB::Util.html_escape(ActiveSupport::NumberHelper.number_to_phone( customer.phone_number, options))
  end
end
