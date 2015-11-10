class ImprintableVariant < ActiveRecord::Base
  belongs_to :imprintable
  belongs_to :color
  belongs_to :size
  has_many :line_items, foreign_key: :imprintable_object_id
  has_one :brand, through: :imprintable

  validates :imprintable, presence: true
  validates :size, presence: true
  validates :color, presence: true
end
