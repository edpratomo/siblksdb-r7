require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do

  describe "student invoice" do
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

    it "initially contains empty items" do
      expect(student_invoice.invoice_items.length).to eq(0)
    end

    let(:item_1) {
      InvoiceItem.new(course: course_1,
                      fee: RegCourseFee.current(course_1),
                      description: "Biaya kursus reguler #{course_1.name}")
    }

    it "now contains one item and its amount should equal the item's amount" do
      expect(reg_course_fee).to eq(RegCourseFee.current(course_1))
      student_invoice.invoice_items << item_1
      student_invoice.reload
      expect(student_invoice.invoice_items.length).to eq(1)
      expect(item_1.invoice.amount).to eq(item_1.fee.amount)
    end

    let(:item_2) {
      InvoiceItem.new(course: course_2,
                      fee: IntCourseFee.current(course_2),
                      description: "Biaya kursus intensif #{course_2.name}")
    }

    it "now contains two items, and the invoice's amount should equal total amount of its items" do
      expect(reg_course_fee).to eq(RegCourseFee.current(course_1))
      # add item #1 to invoice
      student_invoice.invoice_items << item_1

      # force to eval int_course_fee
      expect(int_course_fee).to eq(IntCourseFee.current(course_2))
      expect(student_invoice.invoice_items.length).to eq(1)

      student_invoice.invoice_items << item_2
      expect(student_invoice.invoice_items.length).to eq(2)
      expect(student_invoice.amount).to eq(item_1.fee.amount + item_2.fee.amount)
    end

    it "has item removed" do
      expect(reg_course_fee).to eq(RegCourseFee.current(course_1))
      student_invoice.invoice_items << item_1

      # force to eval int_course_fee
      expect(int_course_fee).to eq(IntCourseFee.current(course_2))
      expect(student_invoice.invoice_items.length).to eq(1)

      student_invoice.invoice_items << item_2
      expect(student_invoice.invoice_items.length).to eq(2)
      expect(student_invoice.amount).to eq(item_1.fee.amount + item_2.fee.amount)

      # delete last item
      student_invoice.reload
      item_2.destroy
      expect(student_invoice.invoice_items.length).to eq(1)
      expect(student_invoice.amount).to eq(item_1.fee.amount)
    end
    
  end
end
