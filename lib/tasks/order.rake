require 'csv'

namespace :order do
  
  task create_crm_orders: :environment do
    Admin::Order.limit(10).each do |admin_order|
      #byebug
      
      order = Order.create_from_admin_order(admin_order)
      order.create_shipment_from_admin_order(admin_order)
      
      admin_order.jobs.each do |aj|
        job = order.create_job_from_admin_job(aj)
        admin_order.line_items.each do |li|
          line = order.create_line_item_from_admin_line_and_job(li, job)
        end
      end
    end
  end

  task create_line_items: :environment do
    lines = []
    start_time = Time.now
    Admin::Order.where(type: "CustomOrder").limit(1000).each do |ao|
      email = ao.admin.email

      next if email.include?"ricky@annarbortshirtcompany.com" || email.include?("chantal@annarbortshirtcompany.com")
      order = Order::create_from_admin_order(ao)

      ao.jobs.each do |aj|
        job = Job::find_or_create_from_admin_job(ao, aj)

        aj.line_items.each do |li|
           line = LineItem::create_from_admin_line_and_job(li, job) 
           lines << line
        end
      end

      if ao.line_items.where(job_id: nil).count > 0
        job = Job.find_or_create_by(
          jobbable_id: order.id, 
          jobbale_type: 'Order',
          name: 'No Job Provided',
          description: 'These line items have no job in the old software'
        )
        
        ao.line_items.where(job_id: nil).each do |li|
           line = LineItem::create_from_admin_line_and_job(li, job) 
           lines << line
        end 
      end

    end

    end_time = Time.now
    final_time = (end_time - start_time) / 60 
    byebug  
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
end
