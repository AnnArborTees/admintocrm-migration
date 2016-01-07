class Color < ActiveRecord::Base
  has_many :imprintable_variants

  validates :name, presence: true

  def self.find_by_admin_color(admin_color)
    color = Color::find_by(name: admin_color.color)
  end
end
