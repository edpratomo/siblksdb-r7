require 'rails_helper'

RSpec.describe BookUniformFee, type: :model do
  let(:first_program_book_uniform_fee) { create(:book_uniform_fee) }
  let(:second_program_book_uniform_fee) { create(:book_uniform_fee, program: Program.second, amount: 50_000) }

  it "belongs to the correct program" do
    expect(first_program_book_uniform_fee.program).to eq(Program.first)
    expect(second_program_book_uniform_fee.program).to eq(Program.second)
  end
  
  it "returns the correct amount" do
    expect(first_program_book_uniform_fee.active_since).not_to be(nil)
    current_first_program_book_uniform_fee = BookUniformFee.current(Program.first)
    expect(current_first_program_book_uniform_fee).not_to be(nil)
    expect(current_first_program_book_uniform_fee.amount).to eq(first_program_book_uniform_fee.amount)
  end
end
