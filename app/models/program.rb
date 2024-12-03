class Program < ApplicationRecord
  # foreign table
  self.table_name = 'siblksdb.programs'
  self.primary_key = 'id'

  has_many :courses
end
