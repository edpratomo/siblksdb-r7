require 'rails_helper'

RSpec.describe AdmissionFee, type: :model do
  before(:each) do
    @past_admission_fee = create(:admission_fee, amount: 50_000, active_since: DateTime.now.months_ago(1))
  end

  it "is valid with valid attributes" do
    expect(@past_admission_fee).to be_valid
  end

  it "returns correct current amount after a new fee replaced the old one" do
    current_admission_fee = AdmissionFee.current
    expect(current_admission_fee).not_to be_nil
    expect(current_admission_fee.amount).to eq(@past_admission_fee.amount)

    @present_admission_fee = create(:admission_fee) # fee for present time
    current_admission_fee = AdmissionFee.current
    expect(current_admission_fee).not_to be_nil
    expect(current_admission_fee.amount).to eq(@present_admission_fee.amount)
  end

  it "returns correct current amount after new fee for future is created" do
    current_admission_fee = AdmissionFee.current
    expect(current_admission_fee).not_to be_nil
    expect(current_admission_fee.amount).to eq(@past_admission_fee.amount)

    @future_admission_fee = create(:admission_fee, amount: 150_000, active_since: DateTime.now.months_since(2))
    current_admission_fee = AdmissionFee.current
    expect(current_admission_fee).not_to be_nil
    expect(current_admission_fee.amount).to eq(@past_admission_fee.amount)
  end
end
