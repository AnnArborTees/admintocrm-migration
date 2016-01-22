require 'csv'

namespace :order do
  
  task create_crm_orders: :environment do
    orders_created = []
    start_time = Time.now
    chantals_found = 0
    rickys_found = 0
    Admin::Order.all.each do |ao|
      email = ao.admin.email
      
      if (email.include?("chantal@"))
        chantals_found += 1
      elsif (email.include?("ricky@"))
        rickys_found += 1
      end
     
      next if ao.title.include? "FBA"
      next if email.include? "chantal@"
      next if email.include? 'ricky@'
      next if ao.status.downcase.include? "cancelled"
      
      order = Order.create_from_admin_order(ao)
      order.create_shipment_from_admin_order(ao)
      orders_created << order

    end
    total_time = (Time.now - start_time) / 60 
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
    byebug  
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
end
