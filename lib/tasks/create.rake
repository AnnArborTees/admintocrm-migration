
namespace :create do

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
    Rake::Task["order:create_crm_orders"].execute

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


  end
end
