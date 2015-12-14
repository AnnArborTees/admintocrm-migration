class Admin::InventorySize < ActiveRecord::Base
  has_many :inventories, class_name: "Admin::Inventory", foreign_key: :size_id
end
