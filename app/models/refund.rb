class Refund < ApplicationRecord
  belongs_to :invoice

  # filter list
  filterrific(
    default_filter_params: { sorted_by: 'created_at_desc', already_paid: false },
    available_filters: [
      :sorted_by,
      :already_paid,
      :with_created_at_gt,
      :with_created_at_lt
    ]
  )

  scope :sorted_by, ->(column_order) { 
    if Regexp.new('^(.+)_(asc|desc)$', Regexp::IGNORECASE).match(column_order)
      reorder("#{$1} #{$2}")
    end
  }

  scope :already_paid, ->(true_or_false) {
    if true_or_false == 1
      where.not(paid_at: nil)
    else
      where(paid_at: nil)
    end
  }

  scope :with_created_at_gt, ->(ref_date) {
    where("created_at AT TIME ZONE 'Asia/Jakarta' > ?", ref_date.sub(Regexp.new('^(\d+)/(\d+)/(\d+)$'), '\2/\1/\3'))
  }

  scope :with_created_at_lt, ->(ref_date) {
    where("created_at AT TIME ZONE 'Asia/Jakarta' < ?", ref_date.sub(Regexp.new('^(\d+)/(\d+)/(\d+)$'), '\2/\1/\3'))
  }

  def self.options_for_sorted_by
    [
      #['Kepada (a-z)', 'invoice.invoiceable.name_asc'],
      ['Tanggal (baru -> lama)', 'created_at_desc'],
      ['Tanggal (lama -> baru)', 'created_at_asc'],
    ]
  end

  def self.options_for_already_paid
    [
      ['Pilih', ''],
      ['Sudah dikembalikan', '1'],
      ['Belum dikembalikan', '0']
    ]
  end
end
