class Fee < ApplicationRecord
  validates_numericality_of :amount, only_integer: true

  has_many :invoice_items

  after_create do
    if self.active_since > DateTime.now
      UpdateInvoiceJob.set(wait_until: self.active_since).perform_later(self.class.to_s, course_id, program_id)
    else
      UpdateInvoiceJob.perform_now(self.class.to_s, course_id, program_id)
    end
  end

  after_destroy do
    UpdateInvoiceJob.perform_now(self.class.to_s, course_id, program_id)
  end
end
