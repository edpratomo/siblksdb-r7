class CreateRefunds < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
CREATE TABLE refunds (
  id SERIAL PRIMARY KEY,
  invoice_id INTEGER NOT NULL REFERENCES invoices(id),
  amount INTEGER NOT NULL,
  reason TEXT NOT NULL DEFAULT 'excess_payment',
  paid_at TIMESTAMP WITH TIME ZONE,
  modified_by TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT clock_timestamp() NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT clock_timestamp() NOT NULL
);

CREATE INDEX ON refunds(paid_at);
SQL
  end

  def down
    drop_table :refunds
  end
end
