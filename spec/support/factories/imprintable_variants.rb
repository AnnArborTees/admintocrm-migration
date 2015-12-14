FactoryGirl.define do
  factory :imprintable_variant do
    imprintable { |i| i.association(:imprintable) }
    size { |s| s.association(:size) }
    color { |c| c.association(:color) }
  end

end
