# nucleus-db

## 1. Introduction

This repository contains the SQL scripts to setup the database entities and relations for Gooru Nucleus. 

## 2. Installation

You will need to install PostgreSQL v9.4 in order to run these scripts. Installation instructions for PostgreSQL v9.4 can be found here: http://www.postgresql.org/docs/9.4/static/installation.html

## 3. Getting started with Nucleus DB

1. After installation, setup the Nucleus DB using the scripts in the sql/setup directory.
2. Once the Role and DB is created, use the script - V1__Nucleus_DB_Baseline.sql to setup the entities.

## 4. Evolving the Nucleus DB
You can evolve the Nucleus DB systematically by integrating with the Flyway tool which can be found here:  
http://flywaydb.org/documentation/existing.html.

1. Generate a baseline schema first using: 
`./flyway baseline -Dflyway.baselineVersion=1 -Dflyway.baselineDescription="Nucleus DB baseline"`

2. Any DB changes that need to be done, can be specified with a script file pattern V*__<filename>.sql 

3. After setting up the script, one can then migrate the current schema to the new desired schema using:
`./flyway migrate` 




