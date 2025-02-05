-- Step 1: Create user
CREATE USER grafanauser WITH PASSWORD 'grafanapass';

-- Step 2: Grant SELECT privilege on all tables in the public schema
GRANT SELECT ON ALL TABLES IN SCHEMA public TO grafanauser;

-- (Optional) If you want the user to be able to access tables in the future, 
-- you can give them the ability to automatically get SELECT privilege on new tables:
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO grafanauser;
