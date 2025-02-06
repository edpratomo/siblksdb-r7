class DropCourseColumnFromInvoice < ActiveRecord::Migration[6.1]
  def change
    execute <<SQL
ALTER TABLE invoices DROP COLUMN IF EXISTS course_id;
SQL
  end
end
