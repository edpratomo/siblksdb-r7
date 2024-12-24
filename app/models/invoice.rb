class Invoice < ApplicationRecord
  # invoice can be polymorphically applied to either admission or student
  belongs_to :invoiceable, polymorphic: true

  has_many :payments
  has_many :invoice_items  
  has_one :refund

  # filter list
  filterrific(
    default_filter_params: { sorted_by: 'created_at_asc' },
    available_filters: [
      :sorted_by,
      :with_paid,
      :with_created_at_gt,
      :with_created_at_lt,
      :with_admission
    ]
  )

  scope :sorted_by, ->(column_order) { 
    if Regexp.new('^(.+)_(asc|desc)$', Regexp::IGNORECASE).match(column_order)
      reorder("#{$1} #{$2}")
    end
  }

  scope :with_paid, ->(true_or_false) {
    where(:paid => true_or_false)
  }

  scope :with_created_at_gt, ->(ref_date) {
    where("created_at AT TIME ZONE 'Asia/Jakarta' > ?", ref_date.sub(Regexp.new('^(\d+)/(\d+)/(\d+)$'), '\2/\1/\3'))
  }

  scope :with_created_at_lt, ->(ref_date) {
    where("created_at AT TIME ZONE 'Asia/Jakarta' < ?", ref_date.sub(Regexp.new('^(\d+)/(\d+)/(\d+)$'), '\2/\1/\3'))
  }

  scope :with_admission, ->(admission) {
    joins(:admission).where(admission: admission)
  }

  def total_paid
    payments.inject(0) {|m,o| m += o.amount; m}
  end

  def atomic_update_fees
    transaction do
      reload
      unless self.paid
        invoice_items.each do |item|
          item.update(fee: item.fee.class.current(item.course || item.program))
        end
        update_amount
      end
    end
  end

  def update_amount
    amount = invoice_items.inject(0) {|m,o| m += o.fee.amount; m}
    update!(amount: amount)
  end

  def self.options_for_sorted_by
    [
      ['Kepada (a-z)', 'invoiceable.name_asc'],
      ['Tanggal invoice (baru -> lama)', 'created_at_desc'],
      ['Tanggal invoice (lama -> baru)', 'created_at_asc'],
    ]
  end
end
