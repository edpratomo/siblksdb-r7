class Student < ApplicationRecord
  # foreign table
  self.table_name = 'siblksdb.students'
  self.primary_key = 'id'

  include Invoiceable
end
