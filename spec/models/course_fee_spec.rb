require 'rails_helper'

RSpec.describe RegCourseFee, type: :model do
  let(:first_course_fee) { create(:reg_course_fee) }
  let(:second_course_fee) { create(:reg_course_fee, course: Course.second, amount: 500_000) }

  it "belongs to the correct courses" do
    expect(first_course_fee.course).to eq(Course.first)
    expect(second_course_fee.course).to eq(Course.second)
  end
  
  it "returns the correct amount" do
    expect(first_course_fee.active_since).not_to be(nil)
    current_first_course_fee = RegCourseFee.current(Course.first)
    expect(current_first_course_fee).not_to be(nil)
    expect(current_first_course_fee.amount).to eq(first_course_fee.amount)
  end
end
