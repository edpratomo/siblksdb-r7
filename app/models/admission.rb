class Admission < ApplicationRecord
  has_many :courses_admissions
  has_many :courses, through: :courses_admissions

  include Invoiceable

  def self.options_for_courses
    Course.joins(:program).order(:program_id, :id).map {|e|
      [e.id, "#{e.program.program} - #{e.name}"]
    }
  end
end
