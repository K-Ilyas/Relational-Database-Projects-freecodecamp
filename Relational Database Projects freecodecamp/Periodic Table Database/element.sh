#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]; then

    if ! [[ $1 =~ ^[0-9]+$ ]]; then
        ELEMENT=$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1' OR name='$1'")
    else
        ELEMENT=$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1")
    fi

    if [[ -z $ELEMENT ]]; then
        echo -e "I could not find that element in the database."

    else
        ${element_array[@]}
        IFS='|' read -r -a element_array <<<"$ELEMENT"
        for ((i = 0; i <= ${#element_array[@]} - 1; i++)); do
            element_array[$i]=$(echo ${element_array[$i]} | sed -e 's/^+ | +$//')
        done
        echo "The element with atomic number ${element_array[0]} is ${element_array[1]} (${element_array[2]}). It's a ${element_array[3]}, with a mass of ${element_array[4]} amu. ${element_array[1]} has a melting point of ${element_array[5]} celsius and a boiling point of ${element_array[6]} celsius."
    fi
else
    echo -e "Please provide an element as an argument."
fi
