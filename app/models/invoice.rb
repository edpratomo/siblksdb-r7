class Invoice < ApplicationRecord
  # invoice can be polymorphically applied to either admission or student
  belongs_to :invoiceable, polymorphic: true

  # the following lines do NOT work:
  # belongs_to :admission, -> { where(invoices: { invoiceable_type: 'Admission' }) }, foreign_key: 'invoiceable_id'
  # belongs_to :student, -> { where(invoices: { invoiceable_type: 'Student' }) }, foreign_key: 'invoiceable_id'

  has_many :payments
  has_many :invoice_items  
  has_one :refund

  validates :invoice_number, uniqueness: true
  before_create :set_invoice_number

  # filter list
  filterrific(
    default_filter_params: { sorted_by: 'created_at_desc' },
    available_filters: [
      :sorted_by,
      :already_paid,
      :with_created_at_gt,
      :with_created_at_lt,
      :with_names
    ]
  )

  scope :sorted_by, ->(column_order) { 
    if Regexp.new('^(.+)_(asc|desc)$', Regexp::IGNORECASE).match(column_order)
      reorder("#{$1} #{$2}")
    end
  }

  scope :already_paid, ->(true_or_false) {
    if true_or_false == 1
      where(paid: true)
    else
      where(paid: false)
    end
  }

  scope :with_created_at_gt, ->(ref_date) {
    where("created_at AT TIME ZONE 'Asia/Jakarta' > ?", ref_date.sub(Regexp.new('^(\d+)/(\d+)/(\d+)$'), '\2/\1/\3'))
  }

  scope :with_created_at_lt, ->(ref_date) {
    where("created_at AT TIME ZONE 'Asia/Jakarta' < ?", ref_date.sub(Regexp.new('^(\d+)/(\d+)/(\d+)$'), '\2/\1/\3'))
  }

  scope :with_names, ->(name) {
    inv_ids = Admission.fuzzy_search(name: name).map {|e| e.invoices }.flatten.map {|e| e.id}
    student_inv_ids = Student.fuzzy_search(name: name).map {|e| e.invoices }.flatten.map {|e| e.id}
    where(id: inv_ids.concat(student_inv_ids))
  }

  def unpaid_amount
    if self.paid
      0
    else
      self.amount - self.total_paid
    end
  end

  def total_paid
    payments.sum(:amount) #inject(0) {|m,o| m += o.amount; m}
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
      ['Tanggal invoice (baru -> lama)', 'created_at_desc'],
      ['Tanggal invoice (lama -> baru)', 'created_at_asc'],
    ]
  end

  def self.options_for_already_paid
    [
      ['Pilih', ''],
      ['Lunas', '1'],
      ['Kurang Bayar', '0']
    ]
  end

  private
  
  def set_invoice_number
    loop do
      self.invoice_number = "INV/#{Time.current.strftime("%Y%m%d")}/" + 
                            self.invoiceable.class.to_s.slice(0,3).upcase + "/" +
                            self.invoiceable.id.to_s + "/" + SecureRandom.hex(3).upcase
      break unless Invoice.exists?(invoice_number: invoice_number)
    end
  end
end
