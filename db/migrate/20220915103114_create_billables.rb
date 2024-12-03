class CreateBillables < ActiveRecord::Migration[6.1]
  def up
    execute <<SQL
CREATE TABLE billables (
    id SERIAL PRIMARY KEY,
    type TEXT NOT NULL,
    course_id INTEGER,
    name TEXT,
    amount INTEGER NOT NULL,
    active_since TIMESTAMP WITH TIME ZONE,
    modified_by TEXT,
    created_at TIMESTAMP with time zone DEFAULT clock_timestamp() NOT NULL,
    modified_at TIMESTAMP with time zone DEFAULT clock_timestamp() NOT NULL
);
SQL
  end

  def down
    drop_table :billables
  end
end
