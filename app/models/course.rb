class Course < ApplicationRecord
  # foreign table
  self.table_name = 'siblksdb.courses'
  self.primary_key = 'id'

  has_many :courses_admissions
  has_many :admissions, through: :courses_admissions
  has_many :course_fees
  belongs_to :program

  def self.options_for_select
    joins(:program).order(:program_id, :id).map {|e|
      ["#{e.program.program} - #{e.name}", e.id]
    }
  end

  def self.options_for_checkbox
    joins(:program).order(:program_id, :id).map {|e|
      [e.id, "#{e.program.program} - #{e.name}"]
    }
  end
end
