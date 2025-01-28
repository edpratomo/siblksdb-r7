module RefundsHelper
  def outstanding_refunds_count
    or_c = Refund.already_paid('0').size
    or_c > 0 ? or_c : ''
  end
end
