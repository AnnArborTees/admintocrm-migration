class Color < ActiveRecord::Base
  has_many :imprintable_variants

  validates :name, presence: true

  def self.find_or_create_by_admin_color_name(ac_name)
    if ac_name.include? "CrÃ¨me"
      ac_name = "Creme"
    end

    color = Color::find_or_create_by(name: ac_name)

    if color.new_record?
      color.save
    end
    return color
  end
end
