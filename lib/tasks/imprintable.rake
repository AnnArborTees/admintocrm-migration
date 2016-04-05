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
    variants_not_found.close
  end

  task find_missing_inventories: :environment do
    missing_inventories = []
    start_time = Time.now

    Admin::LineItem.all.each do |al|
      if al.inventory_id.nil?
        next
      else
        inventory = Admin::Inventory.find_by(id: al.inventory_id)

        missing_inventories << al unless inventory
      end
    end
    finish_time = (Time.now - start_time) / 60

  end

  task create_imprintables: :environment do
    Admin::InventoryLine.all.each do|line|
      imprintable = Imprintable::find_or_create_from_admin_line(line)
    end
  end

  task create_brands: :environment do
    Admin::Brand.all.each do |ab|
      brand = Brand::find_or_create_from_admin_brand_name(ab.name)
    end
  end

  task create_sizes: :environment do
    Admin::InventorySize.all.each do |as|
      size = Size::find_or_create_by_admin_size_name(as.size)
    end
  end

  task create_colors: :environment do
    Admin::InventoryColor.all.each do |ac|
      color = Color::find_or_create_by_admin_color_name(ac.color)
    end
  end
end
