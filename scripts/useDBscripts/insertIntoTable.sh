#! /bin/bash

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

    echo $valid;
}

function tableExists(){
    tableName=$1;
    valid=0     

    if [[ -f Databases/$currDB/Data/$tableName ]]; then
        echo "Table exists." >> log.out;
    else
        echo "$tableName no such table." >> log.out;
        valid=1;    
    fi

    echo $valid;
}


function insertRow(){
    IFS=$'\n' read -d '' -r -a lines < "Databases/$currDB/Metadata/$tableName.metadata"

    newRecord="";
    errorFlag=0; 

    for i in "${!lines[@]}"
    do
        IFS=':' read -r -a column <<< "${lines[i]}";
        colName=${column[0]};
        colDataType=${column[1]};
        colPK=${column[2]};

        dataTypeFlag=0; 
        pkFlag=0;   

        read -p "Enter $colName: " newColValue;
        numRegex='^[0-9]+$'

        if [[ $colDataType == "number" ]]; then
            if ! [[ $newColValue =~ $numRegex ]]; then
                dataTypeFlag=1;
                errorFlag=1; 
                echo "ERROR: Value must be a number.";
            fi 
        fi

        
        if [[ $colPK == "yes" ]]; then
            IFS=$'\n' read -d '' -r -a dataLines < "Databases/$currDB/Data/$tableName"  
            
            e
            for j in "${!dataLines[@]}";
            do
                IFS=':' read -r -a record <<< "${dataLines[$j]}"; 
                if [[ ${record[i]} == $newColValue ]]; then
                    pkFlag=1; 
                    errorFlag=1; 
                    echo "ERROR: Primary key must be unique.";
                fi
            done
        fi

        if [[ dataTypeFlag==0 && pkFlag==0 ]]; then
            if [[ $i == 0 ]]; then
                newRecord=$newColValue;
            else
                newRecord="$newRecord:$newColValue";
            fi
        else
            echo "In-valid record";
        fi
    done


    if ! [[ $newRecord == "" ]]; then
        if [[ $errorFlag == 0 ]]; then
            if echo $newRecord >> "Databases/$currDB/Data/$tableName"; then
                echo "Record stored succesfully.";
            else
                echo "ERROR: Failed to store record.";
            fi
        else
            echo "ERROR: Failed to store record.";
        fi
    else
        echo "ERROR: Record is empty.";
    fi
}


read -p "Enter table name: " tableName;


nameFlag=$(validateTableName "$tableName");
tableExistsFlag=$(tableExists "$tableName");


if [ $nameFlag == 0 ] && [ $tableExistsFlag == 0 ]; then
    insertRow
else
    echo "In-valid table name. Check log.out for more details.";
fi