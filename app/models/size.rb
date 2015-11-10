class Size < ActiveRecord::Base
  has_many :imprintable_variants

  validates :name, presence: true
end
