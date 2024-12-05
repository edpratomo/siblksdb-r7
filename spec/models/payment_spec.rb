require 'rails_helper'

RSpec.describe Payment, type: :model do

  let(:student_invoice) { Invoice.create(invoiceable: Student.last) }
  let(:course_1) { Course.first }
  let(:course_2) { Course.second }
  let(:reg_course_fee) {
      RegCourseFee.create(course: course_1, 
                          amount: 400_000,
                          active_since: 1.second.ago)
  }
  let(:int_course_fee) {
      IntCourseFee.create(course: course_2, 
                          amount: 500_000,
                          active_since: 1.second.ago)
  }

  let(:item_1) {
      InvoiceItem.new(course: course_1,
                      fee: RegCourseFee.current(course_1),
                      description: "Biaya kursus reguler #{course_1.name}")
  }

  describe "full payment" do
    it "initializes student invoice" do
      expect(student_invoice.invoice_items.length).to eq(0)
    end
  
    it "changes invoice's paid to true" do
      expect(reg_course_fee).to eq(RegCourseFee.current(course_1))
      # add item #1 to invoice
      student_invoice.invoice_items << item_1
      student_invoice.reload
      expect(student_invoice.amount).to eq(reg_course_fee.amount)
      student_invoice.pay(student_invoice.amount, "homer")
      expect(student_invoice.paid).to be true
      expect(student_invoice.payments.size).to eq(1)
    end
  end

  describe "partial payment" do
    it "doesn't change invoice's paid to true" do
      expect(reg_course_fee).to eq(RegCourseFee.current(course_1))
      student_invoice.invoice_items << item_1
      student_invoice.reload
      expect(student_invoice.amount).to eq(reg_course_fee.amount)
      student_invoice.pay((student_invoice.amount / 2), "homer")
      expect(student_invoice.paid).to be false
      expect(student_invoice.payments.size).to eq(1)
    end

    it "changes invoice's paid to true after full payment in two installments" do
      expect(reg_course_fee).to eq(RegCourseFee.current(course_1))
      student_invoice.invoice_items << item_1
      student_invoice.reload
      expect(student_invoice.amount).to eq(reg_course_fee.amount)
      student_invoice.pay((student_invoice.amount / 2), "homer")
      expect(student_invoice.paid).to be false
      expect(student_invoice.payments.size).to eq(1)
      student_invoice.pay((student_invoice.amount / 2), "homer")
      expect(student_invoice.paid).to be true
      expect(student_invoice.payments.size).to eq(2)
    end
    
  end
end
