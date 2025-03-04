#!/bin/bash

function validateTableName(){
    valid=0     
    IFS=' ' read -r -a array <<< $1;
    if (( ${#array[@]} > 1 )); then 
        echo "ERROR: Table name can not contain spaces." >> log.out;
        valid=1; 
    fi

    if (( ${#array[@]} == 0 )); then 
        echo "ERROR: Table name can not be empty." >> log.out;
        valid=1; 
    fi

    first="${array[0]:0:1}"
    if [[ $first =~ [0-9] ]]; then
        echo "ERROR: Table name can not begin with number." >> log.out;
        valid=1;
    fi

    if [[ "$1" =~ [A-Za-z] ]]; then
        echo "Valid table name" >> log.out;
    else
        echo "ERROR: Table name must contain at least one letter." >> log.out;
        valid=1;    
    fi

    echo $valid;
}

function tableExists(){
    currDB=$1;
    tableName=$2;

    valid=0     

    if [[ -f Databases/$currDB/Data/$tableName ]]; then
        echo "ERROR: Table already exists." >> log.out;
        valid=1;    
    fi

    echo $valid;
}


function validateColumnName(){
    valid=0     
    IFS=' ' read -r -a array <<< $1;
    if (( ${#array[@]} > 1 )); then 
        echo "ERROR: Column name can not contain spaces." >> log.out;
        valid=1; 
    fi

    if (( ${#array[@]} == 0 )); then 
        echo "ERROR: Column name can not be empty." >> log.out;
        valid=1; 
    fi

    first="${array[0]:0:1}"
    if [[ $first =~ [0-9] ]]; then
        echo "ERROR: Column name can not begin with number." >> log.out;
        valid=1; 
    fi

    if [[ "$1" =~ [A-Za-z] ]]; then
        echo "Valid Column name" >> log.out;
    else
        echo "ERROR: Column name must contain at least one letter." >> log.out;
        valid=1;    
    fi

    echo $valid;
}


function createColumns(){
    read -p "Enter number of columns: " numCols;
     
    for (( i=0; i<$numCols; i++ ))
    do
        colMetadata="";
        read -p "Enter column name: " colName;

        nameFlag=$(validateColumnName "$colName");
        if [[ $nameFlag == 0 ]]; then
            colMetadata="$colName";
            
            read -p "Choose column's datatype String(s) Number(n): (s/n)" colDataType;
            if [[ $colDataType == "s" || $colDataType == "S" ]]; then
                colMetadata="$colMetadata:string";
            elif [[ $colDataType == "n" || $colDataType == "N" ]]; then
                colMetadata="$colMetadata:number";
            fi
            
            read -p "Is it Primary-Key (PK): (y/n)" pk;
            if [[ $pk == "y" || $pk == "Y" ]]; then
                colMetadata="$colMetadata:yes";
            elif [[ $pk == "n" || $pk == "N" ]]; then
                colMetadata="$colMetadata:no";
            fi

            
            echo $colMetadata >> "Databases/$currDB/Metadata/$tableName.metadata";
            
        else
            echo "In-valid column name";
        fi
    done
}

read -p "Enter table name: " tableName;

nameFlag=$(validateTableName "$tableName");
tableExistsFlag=$(tableExists "$currDB" "$tableName");


if [ $nameFlag == 0 ] && [ $tableExistsFlag == 0 ]; then
    if touch "Databases/$currDB/Data/$tableName" 2> log.out; then
        echo "Empty table created sucessfully." >> log.out;
        
        if touch "Databases/$currDB/Metadata/$tableName.metadata" 2> log.out; then
            echo "Metadata file created sucessfully." >> log.out;
        else
            echo "Falied to create metadata. Check log.out for more details.";
        fi

        if createColumns; then
            echo "Table $tableName created sucessfully.";
            cat "Databases/$currDB/Metadata/$tableName.metadata";
        else
            echo "ERROR: Failed to create $tableName."
        fi
    else
        echo "Falied to create table. Check log.out for more details.";
    fi

else
    echo "Can not create table. Check log.out for more details.";
fi