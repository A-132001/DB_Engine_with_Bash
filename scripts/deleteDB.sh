#!/bin/bash

read -p "Enter The Database you want to delete:- " db_name

if [ -d "Databases/$db_name" ]; then
    rm -r "Databases/$db_name"
    echo "Database $db_name deleted successfully"
else
    echo "No Database with this name"
fi