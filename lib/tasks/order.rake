require 'csv'

namespace :order do

  task :create_crm_orders, [:year] => :environment do |t, args|
    abort("Please enter a year in the format YYYY") if args.year.nil?

    Admin::Order.where("created_at like '#{args.year}%'").each do |ao|

      next if ao.title.include? "FBA"
      next if ao.status.downcase.include? "cancelled"
      next if Order.exists?(id: ao.crm_order_id, imported_from_admin: false)

      order = Order::create_from_admin_order(ao)

      ao.jobs.each do |aj|
        job = Job::find_or_create_from_admin_job(order, aj)
        imprint_methods = job.determine_imprint_methods(aj)
        byebug

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
      order.update_attribute(:artwork_state, :in_production)
      order.update_attribute(:notification_state, :picked_up)
      order.update_attribute(:invoice_state, :approved)
      order.update_attribute(:production_state, :complete)

      puts "#{order.id}"
    end
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
    neg_price_admin_lines.close
  end
end
