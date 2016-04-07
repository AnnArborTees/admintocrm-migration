class Size < ActiveRecord::Base
  has_many :imprintable_variants

  validates :display_value, presence: true

  def self.find_or_create_by_admin_size_name(as_name)
    size = Size::find_by(display_value: as_name)
    size = Size::find_by(name: as_name) unless size
    size = Size::create(display_value: as_name) unless size

    if size.new_record?
      size.name = as_name
      size.save
    end

    return size
  end

  def self.find_or_create_by_admin_size(admin_size)
    return Size.find_by(display_value: admin_size.size) if Size.exists?(display_value: admin_size.size)
    return Size.find_by(name: admin_size.size) if Size.exists?(name: admin_size.size)
    Size.create!(
      name: admin_size.size,
      display_value: admin_size.size,
      sort_order: (110 + (admin_size.sort_order || 0 )),
      retail: 0
    )
  end

end
