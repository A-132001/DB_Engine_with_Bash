#!/bin/bash
useDB_main_menu(){
    options=("Show Tables" "Create New Table" "Insert Into Table" "Delete Table" "Update Table" "UseTable" "Return To Main Menu");
     while [[ "$option" != "Return To Main Menu" ]] 
    do
    select option in "${options[@]}"
    do
        case $option in
            "Show Tables") . ./scripts/useDBscripts/showTables.sh;break ;;
            "Create New Table") . ./scripts/useDBscripts/createTable.sh; break;;
            "Insert Into Table") . ./scripts/useDBscripts/insertIntoTable.sh; break;;
            "Delete Table") . ./scripts/useDBscripts/deleteTable.sh; break ;;
            "Update Table") . ./scripts/useDBscripts/updateTable.sh; break ;;
            "UseTable") . ./scripts/useDBscripts/UseTable.sh; break ;;
            "Return To Main Menu") . ./main_menu.sh; exit $? ;;
            *) echo "Invalid option $REPLY";;
        esac
    done
    done
}

read -p "Enter database name: " currDB;

# check if database exists
if [[ -d Databases/$currDB ]]
then
    export  currDB=$currDB;
    echo "$currDB is selected.";
    useDB_main_menu;
else
    echo "Database does not exist.";
    . ./mainMenu.sh
    
fi