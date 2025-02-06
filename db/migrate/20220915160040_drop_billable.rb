class DropBillable < ActiveRecord::Migration[6.1]
  def change
    drop_table :billables
  end
end
