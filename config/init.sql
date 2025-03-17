-- Step 1: Create user (if not already created)
CREATE USER grafanauser WITH PASSWORD 'grafanapass';

-- Step 2: Grant CONNECT permission on the database (important for access)
GRANT CONNECT ON DATABASE statusdb TO grafanauser;

-- Step 3: Grant USAGE on the public schema (allows access to the schema itself)
GRANT USAGE ON SCHEMA public TO grafanauser;

-- Step 4: Grant SELECT on all existing tables (read-only access to current data)
GRANT SELECT ON ALL TABLES IN SCHEMA public TO grafanauser;

-- Step 5: Ensure future tables are accessible (for new tables created later)
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO grafanauser;

INSERT INTO users (id, username, password, authority, email, refresh_token, createdAt, updatedAt)
VALUES (
    1, 
    'example_user', 
    'example_pass', 
    'ADMIN', 
    'email', 
    NULL, 
    '2025-03-05 16:14:33.386+00', 
    '2025-03-05 16:16:32.238+00'
);
