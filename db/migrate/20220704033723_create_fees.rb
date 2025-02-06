class CreateFees < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
CREATE TABLE fees (
  id SERIAL PRIMARY KEY,
  type TEXT NOT NULL,
---  name TEXT NOT NULL,
  amount INTEGER NOT NULL,
  active_since TIMESTAMP WITH TIME ZONE,
  modified_by TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT clock_timestamp() NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT clock_timestamp() NOT NULL
);
SQL
  end

  def down
    drop_table :fees
  end
end
