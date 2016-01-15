require 'csv'

namespace :imprintable do
  
  task variants_not_created: :environment do
    inventories_not_variants = []
    start_time = Time.now

    variants_not_found = CSV.open([Rails.root, "variants_not_found_from_inventories.csv"].join('/'), 'w', {col_sep: "\t"})

    variants_not_found << ["Brand ID", "Brand Name", "Style Cat No.", "Color", "Size", "Reason Not Variant"]
    variants_not_found << [] 
    Admin::Inventory.all.each do |ai|

      imprintable_not_found = false
      color_not_found = false
      size_not_found = false
      reason = ""

      imprintable = Imprintable::find_by_admin_inventory_id(ai.id)
      imprintable_not_found = true unless imprintable
      color = Color::find_by_admin_color(ai.color)
      color_not_found = true unless color 
      size = Size::find_by_admin_size(ai.size)
      size_not_found = true unless size
      variant = ImprintableVariant::find_by(
        imprintable_id: (imprintable.nil? ?  nil : imprintable.id),
        color_id: (color.nil? ? nil : color.id),
        size_id: (size.nil? ? nil : size.id)
        )

      if imprintable_not_found
        if color_not_found
          if size_not_found
            reason = "Imprintable size and color were not found in CRM"
          else
            reason = "Imprintable and color were not found in CRM"
          end
        else
          if size_not_found
            reason = "Imrpintable and size were not found in CRM"
          else
            reason = "Imprintable was not found in CRM"
          end
        end
      else
        if color_not_found
          if size_not_found
            reason = "Imprintable matched but size and color did not"
          else
            reason = "Imprintable and size matched but color did not"
          end
        else
          if size_not_found
            reason = "Imprintable and Color matched but Size did not"
          else
            reason = "Imprintable, color and size were all found.  Imprintable Variant with this criteia does not exist...yet"
          end
        end
      end
        
      inventories_not_variants << ai unless variant       
      variants_not_found << [ai.line.brand.id, ai.line.brand.name, ai.line.catalog_number,ai.color.color, ai.size.size, reason] unless variant 
    end
    finish_time = (Time.now - start_time) / 60
    byebug
    variants_not_found.close
  end

  task imprintables_not_created: :environment do
    inventory_lines_not_imprintables = []
    start_time = Time.now

    imprintable_not_found = CSV.open([Rails.root, "imprintable_not_found.csv"].join('/'), 'w',{col_sep: "\t"})
    imprintable_not_found << ["Brand ID", "Brand Name", "Style Cat No", "Reason Not Imprintable"]
    imprintable_not_found << [] #blank line between data

    Admin::InventoryLine.all.each do |line|
      reason = ""
      
      if(brand = Brand::find_by(name:  line.brand.name))
        imprintable = Imprintable::find_by(
          style_catalog_no: line.catalog_number,
          brand_id: line.brand.id
        )

        reason = "Brand and catalog_no doesn't match imprintable in CRM" unless imprintable
      else
        reason = "Brand not found in CRM"
        imprintable = nil
      end

      imprintable_not_found << [line.brand.id, line.brand.name, line.catalog_number, reason] unless imprintable
      inventory_lines_not_imprintables << line unless imprintable
    end 
  final_time = (Time.now - start_time) / 60  
  imprintable_not_found.close
  byebug
  end

  task find_matching_brands: :environment do
    match = false
    matching_brands = []
    non_matching_brands = []

    Admin::Brand.all.each do |ab|
      Brand.all.each do |b|
        next if match
        if b.name == ab.name
          match = true
          next
        end
      end

      if match
        matching_brands << ab.name
        match = false
      else
        non_matching_brands << ab.name
      end
    end
    byebug
  end 

  task find_matching_sizes: :environment do
    matching_sizes = []
    non_matching_sizes = []

    Admin::InventorySize.all.each do |as|
      size = Size::find_by_admin_size(as)

      matching_sizes << as unless size.nil?
      non_matching_sizes << as unless size
    end
    byebug
  end
end
