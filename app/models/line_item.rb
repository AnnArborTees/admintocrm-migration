class LineItem < ActiveRecord::Base
  has_one :order, through: :job, foreign_key: :jobbable_id
  belongs_to :job, foreign_key: :line_itemable_id
  belongs_to :imprintable_variant, foreign_key: :imprintable_object_id

  validates :job, presence: true
end
