#!/bin/bash

echo "Enter You database Name:- ";

read db_name;

if mkdir Databases/$db_name 2>> log.out; then
    mkdir Databases/$db_name/Data;
    mkdir Databases/$db_name/Metadata;
    echo "$db_name database created successfully";
else
    echo "You can't create database with this name $db_name check log.out for more information";
fi

