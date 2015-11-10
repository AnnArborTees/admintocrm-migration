class Admin::User < ActiveRecord::Base
  has_many :orders, class_name: 'Admin::Order', foreign_key: :customer_id
  self.inheritance_column = :_type_disabled

  validates :first_name, presence: true
  validates :last_name, presence: true
end
