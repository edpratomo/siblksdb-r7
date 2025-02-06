class Program < ApplicationRecord
  # foreign table
  self.table_name = 'siblksdb.programs'
  self.primary_key = 'id'

  has_many :courses

  def self.options_for_select
    all.order(:id).map {|e|
      [ e.program, e.id ]
    }
  end
end
