class SetDefaultAmountToInvoice < ActiveRecord::Migration[6.1]
  def change
    execute <<SQL
ALTER TABLE invoices ALTER COLUMN amount SET DEFAULT 0;
SQL
  end
end
