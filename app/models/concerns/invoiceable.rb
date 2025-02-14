module Invoiceable
  extend ActiveSupport::Concern

  included do
    has_many :invoices, as: :invoiceable, dependent: :destroy
 
    before_destroy do
      puts("before_destroy")
      if invoices.already_paid(1).count > 0
        errors.add(:base, "Tidak dapat dihapus karena sudah ada tagihan yang dibayar.")
        throw(:abort)
      end 
    end 
  end
end
