#/bin/bash

menu=("Show Databases" "Create New Database" "Use Database" "Delete Database" "Exit")

while [[ $menu != "Exit" ]]
do
    select item in "${menu[@]}"
    do
        case $item in
            "Show Databases") . ./scripts/showDB.sh;  break;;
            "Create New Database") . ./scripts/createDB.sh;   break;;
            "Use Database") . ./scripts/useDB.sh  break;;
            "Delete Database") . ./scripts/deleteDB.sh; break;;
            "Exit")  exit 1;;
            *) echo "You choose $REPLY are not in the menu";;
        esac
    done
done