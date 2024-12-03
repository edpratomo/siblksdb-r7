class AddTimestampsToInvoice < ActiveRecord::Migration[6.1]
  def change
    execute <<-SQL
ALTER TABLE invoices ADD COLUMN modified_by TEXT;
ALTER TABLE invoices ADD COLUMN created_at TIMESTAMP WITH TIME ZONE DEFAULT clock_timestamp() NOT NULL;
ALTER TABLE invoices ADD COLUMN modified_at TIMESTAMP WITH TIME ZONE DEFAULT clock_timestamp() NOT NULL;
SQL
  end
end
