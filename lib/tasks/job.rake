require 'csv'
require 'yaml'

namespace :job do
  task imprint_method_finder_test: :environment do 

    years = ["2011", "2012", "2013", "2014", "2015"]

    years.each do |y|
      
      success, failure = 0, 0
      total = 0
      success_percent = 0.0
    
      failures = CSV.open([Rails.root, "unmappable_#{y.to_i}.csv"].join('/'), 'w', {col_sep: "\t"})
      successes = CSV.open([Rails.root, "mappable_#{y.to_i}.csv"].join('/'), 'w', {col_sep: "\t"})
      failures << ['Order ID', 'Job ID', 'Job Name', 'Job Description', 'Proof Image URL'] 
      successes << ['Order ID', 'Job ID', 'Job Name', 'Job Description', 'Imprints', 'Proof Image URL']
      #blank line between headers and info
      failures << []
      successes << []
      imprint_methods = []

      Admin::Job.joins(:order).where("created_at > '#{y.to_i}' && created_at < '#{y.to_i + 1}'").each do |aj|
  	next if aj.order.title.include? "FBA" 
  	job = Job.new_job_from_admin_job(aj)
  	  
  	imprint_methods = job.determine_imprint_methods
  	file_paths = aj.proofs.map{|f| f.file_path}

  	if imprint_methods.empty?
  	 found = false
  	 IMPRINT_HASH.each do |key, value|
  	   if key == aj.id
  	     found = true
  	     imprint_methods << value
  	   end
  	 end
  	 if !found
  	    failure +=1
  	    failures << [aj.custom_order_id, aj.id, aj.title.gsub(',', ' ').strip, aj.description.gsub(',', ' ').strip,] + file_paths
  	 else  
  	   successes << [aj.custom_order_id, aj.id, aj.title.gsub(',', ' ').strip, aj.description.gsub(',', ' ').strip,] + [imprint_methods] + file_paths
  	   success += 1
  	 end
  	else
  	  successes << [aj.custom_order_id, aj.id, aj.title.gsub(',', ' ').strip, aj.description.gsub(',', ' ').strip,] + [imprint_methods] + file_paths
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

  task create_imprints: :environment do
    imprints = []
    start_time = Time.now

    Admin::Order.all.each do |ao|
      email = ao.admin.email
      
      next if email.include?"ricky@" 
      next if email.include?"chantal@"

      order = Order::create_from_admin_order(ao)

      ao.jobs.each do |aj|
        job = Job::find_or_create_from_admin_job(order, aj)
        imprint_methods = job.determine_imprint_methods

        imprint_methods.each do |im|
          imprint = Imprint::create_from_job_and_method(job, im)
          imprints << imprint
        end
      end
    end
    finish_time = (Time.now - start_time) / 60
    byebug
  end

  task find_mismatched_brands: :environment do
    matching_brands = []
    non_matching_brands = []
    found = false
    Admin::Brand.all.each do |ab|
      Brand.all.each do |b|
        if (b.name == ab.name) || found
          found = true
          next
        end
      end

      if found
        matching_brands << ab.name
      else
        non_matching_brands << ab.name
      end

      found = false
    end
  end

  task find_jobs_with_no_proofs: :environment do
    start_time = Time.now
    no_proofs = []
    
    Admin::Order.all.each do |ao|
      ao.jobs.each do |aj|
        next if aj.proofs.count > 0

        no_proofs << aj
      end
    end

    finish_time = (Time.now - start_time) / 60
    byebug
  end
end
