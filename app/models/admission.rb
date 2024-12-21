class Admission < ApplicationRecord
  has_many :courses_admissions
  has_many :courses, through: :courses_admissions

  include Invoiceable

  self.per_page = 10
  
  # filter list
  filterrific(
    default_filter_params: { sorted_by: 'created_at_desc' },
    available_filters: [
        :sorted_by,
        :with_created_at_gt,
        :with_created_at_lt
    ]
  )
  
  scope :sorted_by, ->(column_order) { 
      if Regexp.new('^(.+)_(asc|desc)$', Regexp::IGNORECASE).match(column_order)
        reorder("#{$1} #{$2}")
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
      ["Name (a-z)", "name_asc"],
      ["Registration date (newest first)", "created_at_desc"],
      ["Registration date (oldest first)", "created_at_asc"],
    ]
  end

  def self.options_for_courses
    Course.joins(:program).order(:program_id, :id).map {|e|
      [e.id, "#{e.program.program} - #{e.name}"]
    }
  end
end
