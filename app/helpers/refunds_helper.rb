module RefundsHelper
  def outstanding_refunds_count
    or_c = Refund.already_paid('0').size
    or_c > 0 ? or_c.to_s : ''
  end

  def refunds_count_badge
    if outstanding_refunds_count.empty?
      raw(%Q(<span id="refunds-count"></span>))
    else
      raw(%Q(<span id="refunds-count" class="right badge badge-danger">#{outstanding_refunds_count}</span>))
    end
  end
end
