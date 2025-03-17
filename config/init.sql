-- Step 1: Create user (if not already created)
CREATE USER grafanauser WITH PASSWORD 'grafanapass';

-- Step 2: Grant CONNECT on the database
GRANT CONNECT ON DATABASE statusdb TO grafanauser;

-- Step 3: Grant USAGE on the public schema 
GRANT USAGE ON SCHEMA public TO grafanauser;

-- Step 4: Grant all privileges on all existing tables and sequences
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO grafanauser;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO grafanauser;

-- Step 5: Ensure future tables and sequences are accessible
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO grafanauser;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON SEQUENCES TO grafanauser;