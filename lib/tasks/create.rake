
namespace :create do
# task another_everything: :environment do
#   start_time = Time.now
#   orders = []
#   payments_start = Payment::count
#   imprintables_start = Imprintable::count
#   variants_start = ImprintableVariant::count
#   brands_start = Brand::count
#   colors_start = Color::count
#   sizes_start = Size::count
#   orders_start = Order::count
#   jobs_start = Job::count
#   line_items_start = LineItem::count

#   Admin::Order.limit(5000).each do |ao|
#     next if ao.title.include? "FBA"
#     next if ao.status.downcase.include? "cancelled"

#     order = Order::create_from_admin_order(ao)
#     
#     ao.jobs.each do |aj|
#       job = Job::find_or_create_from_admin_job(order, aj)

#       aj.line_items.each do |li|
#         LineItem::create_from_admin_line_and_job(li, job)
#       end
#     end

#     if ao.line_items.where(job_id: nil).count > 0
#       job = Job::find_or_create_by(
#         jobbable_id: order.id,
#         jobbable_tye: "Order",
#         name: "No Job Provided",
#         description: "This Line Item has no Job in old Software"
#       )

#       ao.line_items.where(job_id: nil).each do |li|
#         LineItem::create_from_admin_line_and_job(li, job)
#       end
#     end
#     Payment::find_by_admin_order(ao)
#     orders << order 
#   end
#   finish_time = (Time.now - start_time) / 60
#   payment_difference = Payment::count - payments_start
#   order_difference = Order::count - orders_start
#   job_difference = Job::count - jobs_start
#   line_item_difference = LineItem::count - line_items_start
#   imprintable_difference = Imprintable::count - imprintables_start
#   variant_difference = ImprintableVariant::count - variants_start
#   size_difference = Size::count - sizes_start
#   brand_difference = Brand::count - brands_start
#   color_difference = Color::count - colors_start
#   
#   puts "Type    Before    After   Difference\n"
#   puts "Order   #{orders_start}   #{Order::count}   #{order_difference}"
#   puts "Job   #{jobs_start}   #{Job::count}   #{job_difference}"
#   puts "LineItem   #{line_items_start}   #{LineItem::count}   #{line_item_difference}"
#   puts "Brand   #{brands_start}   #{Brand::count}   #{brand_difference}"
#   puts "Color   #{colors_start}   #{Color::count}   #{color_difference}"
#   puts "Size   #{sizes_start}   #{Size::count}   #{size_difference}"
#   puts "Imprint   #{imprintables_start}   #{Imprintable::count}   #{imprintable_difference}"
#   puts "Variant   #{variants_start}   #{ImprintableVariant::count}   #{variant_difference}"
#   puts "Payment   #{payments_start}   #{Payment::count}   #{payment_difference}"
# end

  task everything: :environment do
   
    start_time = Time.now 
    payments_start = Payment::count
    imprintables_start = Imprintable::count
    variants_start = ImprintableVariant::count
    brands_start = Brand::count
    colors_start = Color::count
    sizes_start = Size::count
    orders_start = Order::count
    jobs_start = Job::count
    line_items_start = LineItem::count
    shipments_start = Shipment::count
    admin_proofs_start = AdminProof::count
    imprints_start = Imprint::count
    
    Rake::Task["imprintable:create_brands"].execute
    Rake::Task["imprintable:create_sizes"].execute
    Rake::Task["imprintable:create_colors"].execute
    Rake::Task["imprintable:create_imprintables"].execute
    #Rake::Task["order:create_crm_orders"].execute

    finish_time = (Time.now - start_time) / 60
    payment_difference = Payment::count - payments_start
    order_difference = Order::count - orders_start
    job_difference = Job::count - jobs_start
    line_item_difference = LineItem::count - line_items_start
    imprintable_difference = Imprintable::count - imprintables_start
    variant_difference = ImprintableVariant::count - variants_start
    size_difference = Size::count - sizes_start
    brand_difference = Brand::count - brands_start
    color_difference = Color::count - colors_start
    shipment_difference = Shipment::count - shipments_start
    imprint_difference = Imprint::count - imprints_start
    admin_proof_difference = AdminProof::count - admin_proofs_start
    
    puts "Type\t\tBefore\tAfter\tDifference\n"
    puts "Order\t\t#{orders_start}\t#{Order::count}\t#{order_difference}"
    puts "Job\t\t#{jobs_start}\t#{Job::count}\t#{job_difference}"
    puts "LineItem\t#{line_items_start}\t#{LineItem::count}\t#{line_item_difference}"
    puts "Brand\t\t#{brands_start}\t#{Brand::count}\t#{brand_difference}"
    puts "Color\t\t#{colors_start}\t#{Color::count}\t#{color_difference}"
    puts "Size\t\t#{sizes_start}\t#{Size::count}\t#{size_difference}"
    puts "ImpAble\t\t#{imprintables_start}\t#{Imprintable::count}\t#{imprintable_difference}"
    puts "Variant\t\t#{variants_start}\t#{ImprintableVariant::count}\t#{variant_difference}"
    puts "Payment\t\t#{payments_start}\t#{Payment::count}\t#{payment_difference}"
    puts "Shipment\t#{shipments_start}\t#{Shipment::count}\t#{shipment_difference}"
    puts "Imprint\t\t#{imprints_start}\t#{Imprint::count}\t#{imprint_difference}"
    puts "AdProof\t\t#{admin_proofs_start}\t#{AdminProof::count}\t#{admin_proof_difference}"

    byebug
  end
end 
