FactoryGirl.define do
 factory :imprintable do
    
    style_catalog_no '2001'
    style_name 'V Neck'
    brand { |i| i.association(:brand) }
    
  end

end
