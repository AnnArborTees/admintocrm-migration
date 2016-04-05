class Admin::Brand < ActiveRecord::Base
  establish_connection Admin::database_name

  has_many :inventories, class_name: "Admin::Inventory", foreign_key: :brand_id
  has_many :inventory_lines, class_name: "Admin::InventoryLine", foreign_key: :brand_id

  validates :name, presence: true
end
