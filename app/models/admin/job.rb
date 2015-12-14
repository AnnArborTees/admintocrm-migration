class Admin::Job < ActiveRecord::Base
  belongs_to :order, class_name: "Admin::Order", foreign_key: :custom_order_id
  has_many :line_items, class_name: "Admin::LineItem", foreign_key: :job_id
  has_many :proofs, class_name: "Admin::ProofImage", foreign_key: :job_id
  self.inheritance_column = :_type_disabled

  validates :title, presence: true
  validates :description, presence: true 
end
