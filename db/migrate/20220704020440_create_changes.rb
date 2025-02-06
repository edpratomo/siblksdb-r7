class CreateChanges < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
CREATE FUNCTION get_app_user() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
  cur_user TEXT;
BEGIN
  BEGIN
    cur_user := (SELECT username FROM current_app_user);
  EXCEPTION WHEN undefined_table THEN
    cur_user := 'unknown user';
  END;
  RETURN cur_user;
END;
$$;

CREATE FUNCTION if_modified_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_old_data TEXT;
  v_new_data TEXT;
  cur_user TEXT;
BEGIN
  IF (TG_OP = 'UPDATE') THEN
    v_old_data := ROW(OLD.*);
    v_new_data := ROW(NEW.*);
    BEGIN
      cur_user := NEW.modified_by;
    EXCEPTION WHEN undefined_column THEN
      cur_user := NULL;
    END;
    IF cur_user IS NULL THEN
      cur_user := get_app_user();
    END IF;
    INSERT INTO changes (table_name,action,original_data,new_data,query,modified_by) 
    VALUES (TG_TABLE_NAME::TEXT,substring(TG_OP,1,1),v_old_data,v_new_data, current_query(), cur_user);
    RETURN NEW;
  ELSIF (TG_OP = 'DELETE') THEN
    v_old_data := ROW(OLD.*);
    INSERT INTO changes (table_name,action,original_data,query,modified_by)
    VALUES (TG_TABLE_NAME::TEXT,substring(TG_OP,1,1),v_old_data, current_query(),get_app_user());
    RETURN OLD;
  ELSIF (TG_OP = 'INSERT') THEN
    v_new_data := ROW(NEW.*);
    BEGIN
      cur_user := NEW.modified_by;
    EXCEPTION WHEN undefined_column THEN
      cur_user := NULL;
    END;
    IF cur_user IS NULL THEN
      cur_user := get_app_user();
    END IF;
    INSERT INTO changes (table_name,action,new_data,query,modified_by)
    VALUES (TG_TABLE_NAME::TEXT,substring(TG_OP,1,1),v_new_data, current_query(), cur_user);
    RETURN NEW;
  ELSE
    RAISE WARNING '[IF_MODIFIED_FUNC] - Other action occurred: %, at %',TG_OP,now();
    RETURN NULL;
  END IF;
EXCEPTION
  WHEN data_exception THEN
    RAISE WARNING '[IF_MODIFIED_FUNC] - UDF ERROR [DATA EXCEPTION] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
    RETURN NULL;
  WHEN unique_violation THEN
    RAISE WARNING '[IF_MODIFIED_FUNC] - UDF ERROR [UNIQUE] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
    RETURN NULL;
  WHEN OTHERS THEN
    RAISE WARNING '[IF_MODIFIED_FUNC] - UDF ERROR [OTHER] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
    RETURN NULL;
END;
$$;

CREATE FUNCTION update_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.modified_at = now(); 
  RETURN NEW;
END;
$$;


CREATE FUNCTION update_userstamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cur_user TEXT;
BEGIN
  -- NEW.modified_at = now(); 
  cur_user = get_app_user();
  IF cur_user <> 'unknown user' THEN
    NEW.modified_by = cur_user;
  END IF;
  RETURN NEW;
END;
$$;

CREATE TABLE changes (
    id SERIAL PRIMARY KEY,
    table_name text NOT NULL,
    action_tstamp timestamp with time zone DEFAULT clock_timestamp() NOT NULL,
    action text NOT NULL,
    original_data TEXT,
    new_data TEXT,
    query TEXT,
    modified_by TEXT,
    CONSTRAINT changes_action_check CHECK ((action = ANY (ARRAY['I'::text, 'D'::text, 'U'::text])))
);

SQL
  end

  def down
    execute <<-SQL
DROP TABLE IF EXISTS changes;
DROP FUNCTION IF EXISTS update_userstamp;
DROP FUNCTION IF EXISTS update_timestamp;
DROP FUNCTION IF EXISTS if_modified_func;
DROP FUNCTION IF EXISTS get_app_user;
SQL
  end
end
