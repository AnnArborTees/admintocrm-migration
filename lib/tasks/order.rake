require 'csv'

namespace :order do
  
  task create_crm_orders: :environment do
    Admin::Order.limit(10).each do |admin_order|
      #byebug
      order = Order.create_from_admin_order(admin_order)
      order.create_shipment_from_admin_order(admin_order)
    end
  end

  task :imprint_method_finder_test, [:year] => :environment do |y, args|

    success, failure = 0, 0
    total = 0
    success_percent = 0.0
    
    failures = CSV.open([Rails.root, "unmappable_#{args.year.to_i}.csv"].join('/'), 'w', {col_sep: "\t"})
    successes = CSV.open([Rails.root, "mappable_#{args.year.to_i}.csv"].join('/'), 'w', {col_sep: "\t"})
    failures << ['Order ID', 'Job ID', 'Job Name', 'Job Description', 'Proof Image URL'] 
    successes << ['Order ID', 'Job ID', 'Job Name', 'Job Description', 'Imprints', 'Proof Image URL']
    #blank line between headers and info
    failures << []
    successes << []

    Admin::Job.joins(:order).where("created_at > '#{args.year.to_i}' && created_at < '#{args.year.to_i + 1}'").each do |aj|
      next if aj.order.title.include? "FBA" 
      job = Job.new_job_from_admin_job(aj)
     
      imprint_methods = job.determine_imprint_methods
      file_paths = aj.proofs.map{|f| f.file_path}

      if imprint_methods.empty?
        failure +=1
        failures << [aj.custom_order_id, aj.id, aj.title.strip, aj.description.strip,] + file_paths
      else
        successes << [aj.custom_order_id, aj.id, aj.title.strip, aj.description.strip,] + imprint_methods + file_paths
        success +=1
      end
     
      total +=1
    end
   
    success_percent = ((1.0 * success) / (1.0 * total)) * 100.00

    failures.close 
    successes.close
    puts "Success: #{success}, Failure: #{failure} Success Rate: #{ success_percent.round(2) }%"
    puts "\nTotal jobs: #{total}"
  end

  task test_imprintables: :environment do
    imprintables = []
    Admin::Inventory.where("id > 0").each do |ai|
      imprint = Imprintable::find_by_admin_inventory_id(ai.id)
      imprintables << imprint unless imprint.nil? 
    end 
  end

  task test_imprintable_variants: :environment do
    impvars = []
    
    Admin::Inventory.where("id > 0 && id < 100000").each do |ai|
      impvar = ImprintableVariant::find_by_admin_inventory_id(ai.id)
      impvars << impvar unless impvar.nil?
    end
  end

  task test_imprintable_id_finder: :environment do
    impvars = []
    Admin::LineItem.where("id > 0 && id < 10000").each do |al|
      al.set_imprintable
      var_id = al.determine_imprintable_id
      impvars << al.inventory_id unless var_id.nil?
    end
  end

  task test_size_finder: :environment do
    size_name = []
    size_display = []
    size_nil = []

    Admin::Inventory.where("id > 0 && id < 100000").each do |ai|
      s_name = Size::find_by(name: "#{ai.get_size}")
      s_display = Size::find_by(display_value: "#{ai.get_size}")

      if s_name.nil?
        if s_display.nil?
          size_nil << "#{ai.size.id} - #{ai.get_size}"
        else
          size_display << "#{s_display.id} - #{s_display.name}"
        end
      else
        size_name << "#{s_name.id} - #{s_name.name}"
      end
    end
  end

  task test_line_item_imprintable_finder: :environment do
    line_items = []
    Admin::LineItem.all.each do |al|
      
      next if LineItem.find_by(id: al.id)

      line_item = LineItem.create_from_admin_line_item(al)
      
      line_items << line_item unless line_item.nil? 
    end
    byebug
  end

  task test_imprintable_type_finder: :environment do
    imptypes = []
    inventory_ids = []
    Admin::LineItem.where("id > 0 && id < 10000").each do |al|
      al.set_imprintable
      type = al.determine_imprintable_type

      next if type.nil?

      imptypes << type
      inventory_ids << al.inventory_id
    end
    byebug
  end
end
