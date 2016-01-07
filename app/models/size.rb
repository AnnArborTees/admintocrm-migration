class Size < ActiveRecord::Base
  has_many :imprintable_variants

  validates :name, presence: true

  def self.find_by_admin_size(admin_size)
    size = Size::find_by(display_value: admin_size.size)
  end
end
