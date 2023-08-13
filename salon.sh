#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t -c"

echo -e "\n~~~~~ TONSOR 43 ~~~~~\n"

SERVICES=$($PSQL "SELECT service_id, name FROM services")

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "$1\n"
  fi
  
  echo "$SERVICES" | while read SERVICE_ID BAR NAME BAR
  do
    echo "$SERVICE_ID) $NAME"
  done

  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
  1) HAIR ;;
  2) BEARD ;;
  3) COMPLETE ;;
  *) MAIN_MENU "Per favore, seleziona un'opzione valida." ;;
  esac
}

GET_USER_INFO() {
  SERVICE_NAME_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  echo -e "Per favore, digita il tuo numero di telefono:"
  read CUSTOMER_PHONE
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  #if phone is found
  if [[ -z $CUSTOMER_ID ]] 
  then
      echo "Non ti trovo nell'agenda. Come ti chiami?"
      read CUSTOMER_NAME
      INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id=$CUSTOMER_ID")
  fi
  
  echo "A che ora vuoi prenotare, $CUSTOMER_NAME?"
  read SERVICE_TIME

  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(date, customer_id, service_id, time) VALUES('NOW()', $CUSTOMER_ID, '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
  echo "I have put you down for a $SERVICE_NAME_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."
}

HAIR() {
  echo -e "\nPrenotiamo un taglio di capelli."
  GET_USER_INFO
}

BEARD() {
  echo "Prenotiamo solo barba."
  GET_USER_INFO
}

COMPLETE() {
  echo "Prenotiamo taglio più barba."
  GET_USER_INFO
}


MAIN_MENU









