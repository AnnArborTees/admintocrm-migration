class Admin::InventoryColor < ActiveRecord::Base
  establish_connection Admin::database_name

  has_many :inventories, class_name: "Admin::Inventory", foreign_key: :color_id

  validates :color, presence: true
end
