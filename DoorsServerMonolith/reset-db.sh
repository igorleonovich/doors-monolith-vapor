#!/bin/sh

# doorsservermonolith_db_1
DBID="7716df3c48510c6dae697d49ce292beecb89ea7278467bfd26b7cc7d549b05b6"
docker exec -it $DBID psql -U vapor_username -d postgres -c "drop database doors_database" && docker exec -it $DBID psql -U vapor_username -d postgres -c "create database doors_database"
