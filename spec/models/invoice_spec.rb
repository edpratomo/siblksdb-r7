require 'rails_helper'

RSpec.describe Invoice, type: :model do
  it { is_expected.to have_db_column(:invoiceable_id).of_type(:integer) }
  it { is_expected.to have_db_column(:invoiceable_type).of_type(:text) }

  it { is_expected.to belong_to(:invoiceable) }

  describe "course fee changes" do
    include ActiveJob::TestHelper

    let(:student_invoice) { Invoice.create(invoiceable: Student.last) }
    let(:course_1) { Course.first }
    let(:course_2) { Course.second }
    let(:reg_course_fee) {
      RegCourseFee.create(course: course_1,
                          amount: 400_000,
                          active_since: 1.second.ago)
    }
    let(:new_reg_course_fee) {
      RegCourseFee.create(course: course_1,
                          amount: 600_000,
                          active_since: 1.second.ago)
    }

    let(:new_reg_course_fee_5_sec) {
      RegCourseFee.create(course: course_1,
                          amount: 700_000,
                          active_since: 5.second.from_now)
    }

    let(:item_1) {
      InvoiceItem.new(course: course_1,
                      fee: RegCourseFee.current(course_1),
                      description: "Biaya kursus reguler #{course_1.name}")
    }

    it "initializes empty invoice" do
      expect(student_invoice.invoice_items.length).to eq(0)
    end

    it "is increased, while invoice is already paid. invoice amount should not change, paid status should stay true" do
      expect(reg_course_fee).to eq(RegCourseFee.current(course_1))
      # add item #1 to invoice
      student_invoice.invoice_items << item_1
      student_invoice.reload
      expect(student_invoice.amount).to eq(reg_course_fee.amount)
      student_invoice.pay(student_invoice.amount, "homer")
      expect(student_invoice.paid).to be true
      expect(student_invoice.payments.size).to eq(1)

      # course fee increase for course_1
      expect(new_reg_course_fee).to eq(RegCourseFee.current(course_1))
      student_invoice.reload
      expect(student_invoice.paid).to be true
      expect(student_invoice.amount).to eq(reg_course_fee.amount)
      expect(new_reg_course_fee.amount).to eq(RegCourseFee.current(course_1).amount)
    end

    it "is increased while invoice is only paid partially, invoice amount should adjust" do
      expect(reg_course_fee).to eq(RegCourseFee.current(course_1))
      # add item #1 to invoice
      student_invoice.invoice_items << item_1
      student_invoice.reload
      expect(student_invoice.amount).to eq(reg_course_fee.amount)
      student_invoice.pay((student_invoice.amount / 2), "homer")
      expect(student_invoice.paid).to be false
      expect(student_invoice.payments.size).to eq(1)

      # course fee increase for course_1
      expect(new_reg_course_fee).to eq(RegCourseFee.current(course_1))
      student_invoice.reload
      expect(student_invoice.paid).to be false
      expect(student_invoice.amount).to eq(new_reg_course_fee.amount)
      expect(new_reg_course_fee.amount).to eq(RegCourseFee.current(course_1).amount)
    end

    it "is increased but only becomes effective in 5 seconds" do
      expect(reg_course_fee).to eq(RegCourseFee.current(course_1))
      # add item #1 to invoice
      student_invoice.invoice_items << item_1
      student_invoice.reload
      expect(student_invoice.amount).to eq(reg_course_fee.amount)
      student_invoice.pay((student_invoice.amount / 2), "homer")
      expect(student_invoice.paid).to be false
      expect(student_invoice.payments.size).to eq(1)

      # course fee increase for course_1, becomes effective in 5 sec
      expect(new_reg_course_fee_5_sec).to_not be_nil

      # after_create in Fee class enqueue UpdateInvoiceJob
      assert_enqueued_jobs 1, only: UpdateInvoiceJob

      Rails.logger.debug("************** NOW: #{DateTime.now}")

      # this still runs immediately, regardless of at option:
      # perform_enqueued_jobs(at: 5.seconds.from_now)

      expect(RegCourseFee.current(course_1)).to eq(reg_course_fee)
      student_invoice.reload
      expect(student_invoice.amount).to eq(reg_course_fee.amount)

      sleep 5.seconds
      Rails.logger.debug("************** 5 seconds later: #{DateTime.now}")

      # perform the enqueued UpdateInvoiceJob
      perform_enqueued_jobs
      assert_enqueued_jobs 0

      expect(RegCourseFee.all.size).to eq(2)
      expect(RegCourseFee.current(course_1).amount).to eq(new_reg_course_fee_5_sec.amount)
      expect(student_invoice.paid).to be false

      student_invoice.reload
      expect(student_invoice.amount).to eq(new_reg_course_fee_5_sec.amount)
    end
  end

end
