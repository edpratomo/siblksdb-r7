class CoursesAdmission < ApplicationRecord
  belongs_to :admission
  belongs_to :course

  before_save :check_admission_fee
  after_create :create_invoice

  def check_admission_fee
    unless AdmissionFee.current
      Rails.logger.error("ERROR: no current admission fee defined")
      errors.add(:base, "no current admission fee defined")
      throw(:abort)
    end
  end

  def create_invoice
    admission_fee = AdmissionFee.current
    amount = admission_fee.amount
    invoice = Invoice.new(invoiceable: admission, amount: amount)
    invoice_item = InvoiceItem.create!(course: course, fee: admission_fee, description: "Biaya pendaftaran kursus #{course.name}", invoice: invoice)
    invoice.save!
  end
end
