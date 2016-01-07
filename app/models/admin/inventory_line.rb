class Admin::InventoryLine < ActiveRecord::Base
  has_many :inventories, class_name: "Admin::Inventory"
  belongs_to :brand, class_name: "Admin::Brand", foreign_key: :brand_id

  validates :brand, presence: true
  validates :catalog_number, presence: true

end
