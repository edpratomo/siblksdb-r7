class AddCourseColumnToInvoice < ActiveRecord::Migration[6.1]
  def up
    execute <<SQL
ALTER TABLE invoices ADD COLUMN course_id INTEGER NOT NULL; --- REFERENCES siblksdb.courses(id);
SQL
  end
end
