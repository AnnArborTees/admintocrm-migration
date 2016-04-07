require 'csv'

namespace :order do

  task :create_crm_orders, [:year] => :environment do |t, args|
    abort("Please enter a year in the format YYYY") if args.year.nil?

    unmappable = {}
    CSV.foreach( Rails.root.join("Imprintables Not Found", "UnmappableImprints#{args.year}.csv"), headers: true) do |row|
      key = row['Job Name']
      key = key.gsub("\n",'') unless key.nil?
      unmappable[key] = row['Print Description']
    end

    Admin::Order.where("created_at like '#{args.year}%'").each do |ao|
      next if ao.title.include? "FBA"
      next if ao.status.downcase.include? "cancelled"
      next if Order.exists?(id: ao.crm_order_id, imported_from_admin: false)

      order = Order::create_from_admin_order(ao)
      LineItem.where(id: order.line_items.map(&:id)).destroy_all
      order.jobs.destroy_all
      order.payments.destroy_all
      order.shipments.destroy_all
      order.reload

      ao.jobs.each do |aj|
        job = Job::find_or_create_from_admin_job(order, aj)
        imprint_methods = job.determine_imprint_methods(aj, unmappable)

        imprint_methods.each do |im|
          Imprint::create_from_job_and_method(job, im)
        end

        aj.proofs.each do |ap|
          AdminProof::create_from_order_id_and_proof(order.id, ap)
        end

        aj.line_items.each do |li|
          LineItem::create_from_admin_line_item_and_job(li, job)
        end
      end

      if ao.order_line_items.count > 0
        job = Job::create!(
          jobbable_id: order.id,
          jobbable_type: "Order",
          name: "No Job Was Selected",
          description: "This Line Item has no Job in old Software"
        )

        ao.order_line_items.each do |li|
          LineItem::create_from_admin_line_item_and_job(li, job)
        end
      end

      order.recalculate_totals!
      order.create_payment!(ao)
      order.create_shipment!(ao)
      order.update_all_timestamps(ao)

      order.update_column(:artwork_state, :in_production)
      order.update_column(:notification_state, :picked_up)
      order.update_column(:invoice_state, :approved)
      order.update_column(:production_state, :complete)

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
