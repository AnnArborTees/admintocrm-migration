class Admin::InventorySize < ActiveRecord::Base
  establish_connection Admin::database_name

  has_many :inventories, class_name: "Admin::Inventory", foreign_key: :size_id
end
