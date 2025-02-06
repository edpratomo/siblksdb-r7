class CreateInvoiceItems < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
CREATE TABLE invoice_items (
  id SERIAL PRIMARY KEY,
  invoice_id INTEGER NOT NULL REFERENCES invoices(id),
  quantity INTEGER NOT NULL DEFAULT 1,
  amount INTEGER NOT NULL,
  description TEXT NOT NULL
);
SQL
  end

  def down
    drop_table :invoice_items
  end
end
