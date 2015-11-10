class Store < ActiveRecord::Base
  has_many :orders, foreign_key: :store_id

  validates :name, presence: true

  def self.determine_store_name(admin_order) 
    name = admin_order.ship_method
    if name.nil? || !name.downcase.include?("ypsi")
      return "Ann Arbor T-shirt Company"
    else
      return "Ypsilanti T-shirt Company"
    end
  end

  def self.find_or_create_from_admin_order(admin_order)
    store = Store.find_or_initialize_by(
      name: determine_store_name(admin_order) 
    )

    store.save if store.valid?
    return store if store.valid?
  end
end
