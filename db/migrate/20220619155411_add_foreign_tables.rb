class AddForeignTables < ActiveRecord::Migration[6.1]
  def up
    rails_env = ENV['RAILS_ENV'] || 'development'
    db_suffix = if rails_env == "development"
      "dev"
    elsif rails_env == "production"
      "prod"
    else
      rails_env
    end
    siblksdb_ro_password = ENV['SIBLKSDB_RO_PASSWORD']
    execute <<-SQL
CREATE EXTENSION IF NOT EXISTS "postgres_fdw";
CREATE EXTENSION IF NOT EXISTS "hstore";
CREATE EXTENSION IF NOT EXISTS "pg_redispub";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE SERVER myserver_#{db_suffix} FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '127.0.0.1', dbname 'siblksdb_#{db_suffix}');
CREATE USER MAPPING FOR siblksdb SERVER myserver_#{db_suffix} OPTIONS (user 'siblksdb_ro', password '#{siblksdb_ro_password}');
CREATE SCHEMA IF NOT EXISTS siblksdb;
IMPORT FOREIGN SCHEMA public EXCEPT (ar_internal_metadata, schema_migrations) FROM SERVER myserver_#{db_suffix} INTO siblksdb;
ALTER DATABASE siblksdb_v2_#{db_suffix} SET SEARCH_PATH TO public;
SET SEARCH_PATH TO public;
SQL
  end

  def down

  end
end
