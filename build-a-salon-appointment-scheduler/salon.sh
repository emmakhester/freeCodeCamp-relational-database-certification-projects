#!/bin/bash

# WARNING: DO NOT USE CLEAR IN THIS SCRIPT OR IT WILL FAIL TESTING

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n=== MY SALON ===\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  # Greet and prompt service selection
  echo "Welcome to my salon, how can I help you?"
  echo -e "\n1) cut\n2) color\n3) perm\n"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) CUT_APPOINTMENT ;;
    2) COLOR_APPOINTMENT ;;
    3) PERM_APPOINTMENT ;;
    *) MAIN_MENU "Please enter a valid option." ;;
  esac
}

CUT_APPOINTMENT() {
  SERVICE_ID_SELECTED=1
  # Get customer info
  echo -e "\nWhat is your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';")

  # If customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # Get new customer name
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME

    # Insert new customer (name, phone)
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")
  fi

  # Get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # Insert appointment (customer_id, service_id, time)
  echo -e "\nAt what time would you like your appointment?"
  read SERVICE_TIME
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
  echo -e "\nI have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME."
}

COLOR_APPOINTMENT() {
  SERVICE_ID_SELECTED=2
  # Get customer info
  echo -e "\nWhat is your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';")

  # If customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # Get new customer name
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME

    # Insert new customer (name, phone)
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")
  fi

  # Get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # Insert appointment (customer_id, service_id, time)
  echo -e "\nAt what time would you like your appointment?"
  read SERVICE_TIME
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
  echo -e "\nI have put you down for a color at $SERVICE_TIME, $CUSTOMER_NAME."
}

PERM_APPOINTMENT() {
  SERVICE_ID_SELECTED=3
  # Get customer info
  echo -e "\nWhat is your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';")

  # If customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # Get new customer name
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME

    # Insert new customer (name, phone)
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")
  fi

  # Get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # Insert appointment (customer_id, service_id, time)
  echo -e "\nAt what time would you like your appointment?"
  read SERVICE_TIME
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
  echo -e "\nI have put you down for a perm at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU
