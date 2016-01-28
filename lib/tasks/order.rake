require 'csv'

namespace :order do
  
  task create_crm_orders: :environment do
    Admin::Order.limit(3000).each do |ao|
      next if ao.title.include? "FBA"
      next if ao.status.downcase.include? "cancelled"
      
      order = Order::create_from_admin_order(ao)

      ao.jobs.each do |aj|
        job = Job::find_or_create_from_admin_job(order, aj)
        imprint_methods = job.determine_imprint_methods(aj)
        
        imprint_methods.each do |im|
          Imprint::create_from_job_and_method(job, im)
        end

        aj.proofs.each do |ap|
          AdminProof::create_from_admin_job_and_proof(aj, ap) 
        end

        aj.line_items.each do |li|
          LineItem::create_from_admin_line_and_job(li,job)
        end
      end

      if ao.line_items.where(job_id: nil).count > 0
        job = Job::find_or_create_by(
          jobbable_id: order.id,
          jobbable_type: "Order",
          name: "No Job Provided",
          description: "This Line Item has no Job in old Software"
        )

        ao.line_items.where(job_id: nil).each do |li|
          LineItem::create_from_admin_line_and_job(li, job)
        end
      end

      Payment::find_by_admin_order(ao)
      Shipment::new_shipment_from_admin_order(ao)
    end
  end

  task find_mismatched_orders: :environment do
    missing_orders = []
    start_time = Time.now
    match = false

    Admin::Order.limit(1000).each do |ao|
      Order.all.each do |o|
        if match
          next
        end
      
        if o.id == ao.id
          match = true
        end
      end

      if match
        match = false
        next
      else
        missing_orders << ao      
      end
    end

    byebug
  end

  task create_line_items: :environment do
    lines = []
    orders = []
    jobless = []
    start_time = Time.now
    Admin::Order.where(type: "CustomOrder").limit(1000).each do |ao|
      email = ao.admin.email

      next if email.include?"ricky@annarbortshirtcompany.com" || email.include?("chantal@annarbortshirtcompany.com")
      order = Order::create_from_admin_order(ao)

      ao.jobs.each do |aj|
        job = Job::find_or_create_from_admin_job(order, aj)

        aj.line_items.each do |li|
           line = LineItem::create_from_admin_line_and_job(li, job) 
           lines << line
           orders << order
        end
      end

      if ao.line_items.where(job_id: nil).count > 0
        jobless << ao
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
  end

  task find_admin_line_items_with_negative_price: :environment do
    neg_lines = []
    neg_price_admin_lines = CSV.open([Rails.root, "neg_price_admin_line_items.csv"].join('/'), 'w',{col_sep: "\t"})
    neg_price_admin_lines << ["Name", "Description", "Quantity", "Price"]
    neg_price_admin_lines << []
    Admin::LineItem.where("unit_price < ?", 0).each do |li|
      neg_lines << li
      neg_price_admin_lines << [li.product, li.description, li.quantity, "$#{li.unit_price.to_f}"]
    end
    byebug
    neg_price_admin_lines.close
  end

  task find_lines_with_no_imprintable_type: :environment do
    no_variant_or_imprintable = []
    LineItem::all.each do |li|
      type = li.imprintable_object_type

      if (type == "Imprintable" || type == "Imprintable Variant" || type == "ImprintableVariant")
        #no_variant_or_imprintable << li
        next
      elsif type.nil?
        no_variant_or_imprintable << li
        #next
      end
    end
    byebug
  end

  task create_admin_proofs: :environment do
    start_time = Time.now
    proofs_created = []
    nils_found = []

    Order.all.each do |o|

      ao = Admin::Order.find_by(id: o.id)

      if ao.nil?
        nils_found << o
        next
      else
        if o.imported_from_admin
          ao.jobs.each do |aj|
            aj.proofs.each do |ap|
              proof = AdminProof::create_from_admin_job_and_proof(aj, ap)
              proofs_created << proof
            end
          end
        end
      end
    end
    finish_time = (Time.now - start_time) / 60
  end

  task find_messed_up_proofs: :environment do
    start_time = Time.now
    proofs_messed_up = []

    AdminProof::all.each do |ap|
      if ap.file_url.include? "nil"
        proofs_messed_up << ap
      end
    end

    finish_time = (Time.now - start_time) / 60
    byebug
  end
end
