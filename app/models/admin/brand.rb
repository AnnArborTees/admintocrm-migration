class Admin::Brand < ActiveRecord::Base 
  has_many :inventories, class_name: "Admin::Inventory", foreign_key: :brand_id
end
