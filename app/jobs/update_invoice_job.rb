class UpdateInvoiceJob < ApplicationJob
  queue_as :default

  def perform(*args)
    fee_class, course_id, program_id = *args

    items = if course_id.nil? and program_id.nil?
      InvoiceItem.joins(:invoice).joins(:fee).where("invoices.paid IS FALSE AND fees.type = ?", fee_class).group(:id).group(:invoice_id)
    elsif course_id
      InvoiceItem.joins(:invoice).joins(:fee).where("invoices.paid IS FALSE AND fees.type = ? AND fees.course_id = ?", fee_class, course_id).
                  group(:id).group(:invoice_id)
    elsif program_id
      InvoiceItem.joins(:invoice).joins(:fee).where("invoices.paid IS FALSE AND fees.type = ? AND fees.program_id = ?", fee_class, program_id).
                  group(:id).group(:invoice_id)
    end

    # recalculate amount after fee's amount changes
    items.each do |item|
      Rails.logger.debug("running atomic_update_fees for invoice: #{item.invoice.id}")
      item.invoice.atomic_update_fees
    end
  end
end
