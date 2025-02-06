class CreateSchemaForTest < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
CREATE SCHEMA IF NOT EXISTS siblksdb;

--- create courses table
CREATE TABLE IF NOT EXISTS siblksdb.courses (
    id SERIAL PRIMARY KEY,
    name text NOT NULL,
    idn_prefix text DEFAULT ''::text NOT NULL,
    head_instructor_id integer,
    program_id integer
);

--- create students table
CREATE TABLE IF NOT EXISTS siblksdb.students (
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
    registered_at timestamp with time zone DEFAULT clock_timestamp() NOT NULL,
    employment text DEFAULT 'belum bekerja'::text NOT NULL,
    CONSTRAINT students_sex_check CHECK ((sex = ANY (ARRAY['female'::text, 'male'::text])))
);
SQL
  end
end
