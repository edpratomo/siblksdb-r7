class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :fee
  belongs_to :course

  #after_commit do
  after_update do
    invoice.update_amount
  end
end
