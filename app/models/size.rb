class Size < ActiveRecord::Base
  has_many :imprintable_variants

  validates :name, presence: true

  def self.find_by_admin_size(admin_size)
    size = Size::find_by(name: admin_size.size)
    return size unless size.nil?
    size = Size::find_by(display_value: admin_size.size)
    return size
  end
end
