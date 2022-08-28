#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~"
# main menu
MAIN_MENU() {
    if [[ $1 ]]; then
        echo -e "\nI could not find that service. What would you like today?"
    else
        echo -e "\nWelcome to My Salon, how can I help you?"
    fi
    SERVICES=$($PSQL "SELECT * FROM services")
    echo "$SERVICES" | while read SERVICE_ID BAR NAME; do
        echo -e "$SERVICE_ID) $NAME"
    done
    read SERVICE_ID_SELECTED
    case $SERVICE_ID_SELECTED in
    1 | 2 | 3 | 4 | 5) OFFER_SERVICE ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
    esac

}

# offer service
OFFER_SERVICE() {
    echo -e "What's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_NAME ]]; then
        echo -e "\nI don't have a record for that phone number, what's your name?"
        read CUSTOMER_NAME
        INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
    fi
    echo -e "\nWhat time would you like your $CUSTOMER_NAME, Fabio?"
    read SERVICE_TIME

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

    INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    echo -e "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME.
"
}

MAIN_MENU
