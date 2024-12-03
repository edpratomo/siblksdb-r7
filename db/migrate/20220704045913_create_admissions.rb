class CreateAdmissions < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
CREATE TABLE admissions (
    id SERIAL PRIMARY KEY,
    name text NOT NULL,
    birthplace text,
    birthdate date,
    sex text NOT NULL,
    phone text,
    email text,
    created_at timestamp with time zone DEFAULT clock_timestamp() NOT NULL,
    modified_at timestamp with time zone DEFAULT clock_timestamp() NOT NULL,
    modified_by text,
    avatar_file_name character varying(255),
    avatar_content_type character varying(255),
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone,
    biodata hstore,
    religion text,
    street_address text,
    district text,
    regency_city text,
    province text,
    employment text DEFAULT 'belum bekerja'::text NOT NULL,
    CONSTRAINT students_sex_check CHECK ((sex = ANY (ARRAY['female'::text, 'male'::text])))
);
SQL
  end

  def down
    drop_table :admissions
  end
end
