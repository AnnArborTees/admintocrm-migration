namespace :payment do

  task find_multiple_payments: :environment do
    multiple_payments = []
    start_time = Time.now

    Admin::Order.where(type: "CustomOrder").each do |ao|
      next if ao.payments.count < 2
      multiple_payments << ao
    end
    time_took = (Time.now - start_time) / 60

  end

  task test_payments: :environment do
    payments = []
    start_time = Time.now
    Admin::Order.where(type: "CustomOrder").limit(1000).each do |ao|
      email = ao.admin.email
      next if email.include?"ricky@annarbortshirtcompany.com" || email.include?("chantal@annarbortshirtcompany.com")
      order = Order::create_from_admin_order(ao)

      ao.payments.each do |p|
        payment = Payment::find_by_admin_payment(p)
        payments << payment
      end
    end
      finish_time = (Time.now - start_time) / 60

  end

  task create_discounts: :environment do
    discounts = []
    ricky_or_chantal = []

    Admin::Order.where(type: "CustomOrder").each do |ao|
      email = ao.admin.email

      next if email.include?"ricky@" || (email.include?("chantal@"))

      order = Order::create_from_admin_order(ao)
      ao.payments.each do |ap|
        if ap.amount < 0
          discount = Discount::find_by_admin_payment(ap)
          discounts << discount
        end
      end
    end

  end

  task create_totals: :environment do

    totals = []
    discounts = []
    admin_order_totals = []
    total_money = 0
    payments_applied_totals = []
    mismatched_payments = []
    start_time = Time.now

    Admin::Order.where(type: "CustomOrder").limit(2000).each do |ao|

      subtotal = 0
      tax = 0
      total = 0
      payment_total = 0
      email = ao.admin.email

      next if email.include?"ricky@" || email.include?("chantal@")

      order = Order::create_from_admin_order(ao)
      ao.jobs.each do |aj|
        job = order.create_job_from_admin_job(aj)

        aj.line_items.each do |li|
          line = job.create_line_item_from_admin_line_item(li)
          subtotal += line.determine_subtotal
          tax = line.determine_tax(subtotal)
        end
      end

      if ao.line_items.where(job_id: nil).count > 0
        job = Job.find_or_create_by(
          jobbable_id: order.id,
          jobbable_type: "Job",
          name: "No Job Provided",
          description: "These line items have no job in old software"
        )

        ao.line_items.each do |li|
          line = job.create_line_item_from_admin_line_item(li)
          subtotal += line.determine_subtotal
          tax = line.determine_tax(subtotal)
        end
      end

      #subtotal = ao.subtotal.to_f
      #total = ao.total.to_f
      #tax = ao.tax.to_f
      total = subtotal + tax
      totals << "#{order.name} ==> $#{sprintf('%.2f', total)}" unless (total == 0)

      ao.payments.each do |ap|
        if ap.amount < 0
          discount = Discount::find_by_admin_payment(ap)
          payment_total += discount.amount.to_f
          discounts << discount
        else
          payment = Payment::find_by_admin_payment(ap)
          payment_total += payment.amount.to_f
        end
      end

      payment_total = sprintf('%.2f', payment_total).to_f
      total = sprintf('%.2f', total ).to_f

      if payment_total == total
        totals << "#{order.name} ==> Subtotal: $#{subtotal} ==> Tax: $#{tax} ==> Total: $#{sprintf('%.2f', total)} ==> Payment: $#{payment_total}" unless (total == 0)
        payments_applied_totals << "#{order.name} ==> $#{sprintf('%.2f', total)} ==> #{payment_total}"
        total_money += sprintf('%.2f', total).to_f
      else
        mismatched_payments << "#{order.name}=>Total: $#{total}=>Payment: $#{payment_total}"
      end
    end
    finish_time = (Time.now - start_time) / 60

  end
end
