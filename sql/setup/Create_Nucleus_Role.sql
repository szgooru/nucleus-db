-- You can run this command using the default postgres (aka superuser) role created by postgres:
-- psql -U postgres -f <path to>/Create_Nucleus_Role.sql

-- DROP ROLE nucleus;
CREATE ROLE nucleus WITH INHERIT LOGIN REPLICATION PASSWORD 'nucleus';

