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
    
    failures << ['Order ID', 'Job ID', 'Job Name', 'Job Description'] 
    successes << ['Order ID', 'Job ID', 'Job Name', 'Job Description', 'Imprints']
    failures << []
    successes << []

    Admin::Job.joins(:order).where("created_at > '#{args.year.to_i}' && created_at < '#{args.year.to_i + 1}'").each do |aj|
      next if aj.order.title.include? "FBA" 
      job = Job.new_job_from_admin_job(aj)
     
      imprint_methods = job.determine_imprint_methods

      if imprint_methods.empty?
        failure +=1
        failures << [aj.custom_order_id, aj.id, aj.title.strip, aj.description.strip]
      else
        successes << [aj.custom_order_id, aj.id, aj.title.strip, aj.description.strip,] + imprint_methods
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

end
