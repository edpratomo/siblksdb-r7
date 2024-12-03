class Course < ApplicationRecord
  # foreign table
  self.table_name = 'siblksdb.courses'
  self.primary_key = 'id'

  has_many :courses_admissions
  has_many :admissions, through: :courses_admissions
  has_many :course_fees
  belongs_to :program
end
