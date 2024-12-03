class AddCourseToFee < ActiveRecord::Migration[6.1]
  def change
    execute <<SQL
ALTER TABLE fees ADD COLUMN course_id INTEGER;
SQL
  end
end
