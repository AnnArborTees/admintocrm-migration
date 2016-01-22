namespace :color do
  task find_matching_colors: :environment do
    colors_not_found = []
    colors_found = []
    Admin::InventoryColor.all.each do |ac|
      color = Color::find_by(name: ac.color)
      
      colors_found << "#{ac.color} <==> #{ac.sku_code}" unless color.nil?
      colors_not_found << "#{ac.color} <==> #{ac.sku_code}" unless color
    end
    byebug
  end
end
