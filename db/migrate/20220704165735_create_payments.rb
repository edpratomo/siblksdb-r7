class CreatePayments < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
CREATE TABLE payments (
  id SERIAL PRIMARY KEY,
  invoice_id INTEGER NOT NULL REFERENCES invoices(id),
  amount INTEGER NOT NULL,
  modified_by TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT clock_timestamp() NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT clock_timestamp() NOT NULL
);
SQL
  end

  def down
    drop_table :payments
  end
end
