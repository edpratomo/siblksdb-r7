class CreateInvoices < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
CREATE TABLE invoices (
  id SERIAL PRIMARY KEY,
  invoiceable_type TEXT NOT NULL,
  invoiceable_id INTEGER NOT NULL,
  amount INTEGER NOT NULL,
  paid BOOLEAN NOT NULL DEFAULT FALSE
);
SQL
  end

  def down
    drop_table :invoices
  end
end
