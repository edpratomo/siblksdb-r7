class Payment < ApplicationRecord
  belongs_to :invoice

  after_save :update_paid_status if :fully_paid?
  after_save :create_refund if :overpaid?

  def fully_paid?
    self.invoice.total_paid >= self.invoice.amount
  end

  def overpaid?
    self.invoice.total_paid > self.invoice.amount
  end

  def update_paid_status
    self.invoice.update_column(:paid, true)
  end

  def create_refund
    Refund.create(invoice: self.invoice, amount: self.invoice.total_paid - self.invoice.amount, modified_by: "system")
  end
end
