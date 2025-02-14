module Invoiceable
  extend ActiveSupport::Concern

  included do
    has_many :invoices, as: :invoiceable #, dependent: :destroy
 
    before_destroy do
      if invoices.has_payments.count > 0
        errors.add(:base, "Tidak dapat dihapus karena sudah ada tagihan yang dibayar.")
        throw(:abort)
      else
        invoices.each do |invoice|
          invoice.invoice_items.destroy_all
        end
      end 
    end 
  end
end
