namespace :imprintable do
  
  task variants_not_created: :environment do
    inventories_not_variants = []
    start_time = Time.now

    Admin::Inventory.all.each do |ai|
      imprintable = Imprintable::find_by_admin_inventory_id(ai.id)
      inventories_not_variants << ai unless imprintable
      next if imprintable.nil?
      color = Color::find_by_admin_color(ai.color)
      inventories_not_variants << ai unless color
      next if color.nil?
      size = Size::find_by_admin_size(ai.size)
      inventories_not_variants << ai unless size
      next if size.nil?
      variant = ImprintableVariant::find_by(
        imprintable_id: (imprintable.nil? ?  nil : imprintable.id),
        color_id: (color.nil? ? nil : color.id),
        size_id: (size.nil? ? nil : size.id)
        )

      inventories_not_variants << ai unless variant       
    end
    finish_time = (Time.now - start_time) / 60
    byebug
  end

  task imprintables_not_created: :environment do
    inventory_lines_not_imprintables = []
    start_time = Time.now

    Admin::InventoryLine.all.each do |line|
      if(brand = Brand::find_by(name:  line.brand.name))
        imprintable = Imprintable::find_by(
          style_catalog_no: line.catalog_number,
          brand_id: line.brand.id
        )
      else
        imprintable = nil
      end

      inventory_lines_not_imprintables << line unless imprintable
    end 
  final_time = (Time.now - start_time) / 60  
  byebug
  end 
end
