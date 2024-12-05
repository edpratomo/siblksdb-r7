require 'rails_helper'

RSpec.describe Fee, type: :model do

  it 'subclasses should inherit behavior from Fee' do
    expect(AdmissionFee.superclass).to eq(Fee)
    expect(CourseFee.superclass).to eq(Fee)
    expect(BookUniformFee.superclass).to eq(Fee)
  end
end
