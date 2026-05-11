-- Session-level visibility checks

SELECT current_database() AS database_name;
SELECT current_schema() AS schema_name;

-- Optional safety in manual sessions:
-- SET search_path TO public;
