class AddFeeToInvoiceItem < ActiveRecord::Migration[6.1]
  def up
    execute <<SQL
ALTER TABLE invoice_items ADD COLUMN fee_id INTEGER NOT NULL REFERENCES fees(id);
ALTER TABLE invoice_items ADD COLUMN course_id INTEGER NOT NULL;
ALTER TABLE invoice_items DROP COLUMN amount;
SQL
  end

  def down
    execute <<SQL
ALTER TABLE invoice_items DROP COLUMN fee_id;
ALTER TABLE invoice_items DROP COLUMN course_id;
SQL
  end
end
