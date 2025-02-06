class CreateCoursesAdmissions < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
CREATE TABLE courses_admissions (
  id SERIAL PRIMARY KEY,
  admission_id INTEGER NOT NULL REFERENCES admissions(id),
  course_id INTEGER NOT NULL, --- REFERENCES siblksdb.courses(id),
  modified_by TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT clock_timestamp() NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT clock_timestamp() NOT NULL
);
SQL
  end

  def down
    drop_table :courses_admissions
  end
end
