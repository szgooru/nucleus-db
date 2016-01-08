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
>./flyway baseline -Dflyway.baselineVersion=1 -Dflyway.baselineDescription="Nucleus DB baseline"

2. Any DB changes that need to be done, can be specified with a script file pattern V*__script_name.sql. 

3. After setting up the script, one can then migrate the current schema to the new desired schema using:
>./flyway migrate

Note: 
The version number needs to be incremented each time we want to make changes to the DB, so flyway can keep track of the state of the DB using the script name. For example, if, say the User table from the V1 script needs to be altered, you should add the script to a file that follows a convention as: V2__Alter_User_Table.sql. The DB should then be migrated using the migrate command. Any new tables that get added after the V2 changes are applied calls for incrementing the version number and followed by a meaningful script name, e.g. V3__Add_FooBar_Table.sql and so on. 


## 5. Guidelines
1. All the types now end in suffix _type
2. The column name and column type should not be same token
3. Except for taxonomy and probably user area, all the primary keys if they are individual columns should be named as id
4. The time stamps column should be named as created_at and updated_at



