FactoryGirl.define do
 factory :imprintable do
    style_catalog_no '2001'
    style_name 'Unisex Fine Jersey Long Sleeve Tee'
    brand { |i| i.association(:brand) }
 end
end
