class Admin::Job < ActiveRecord::Base
  belongs_to :order, class_name: "Admin::Order", foreign_key: :custom_order_id
  self.inheritance_column = :_type_disabled

  validates :title, presence: true
  validates :description, presence: true
end
