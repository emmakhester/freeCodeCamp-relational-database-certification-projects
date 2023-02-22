#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Generate random number between 1 and 1000
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))

# Prompt user for username up to 22 characters long
# echo -e "\nUsernames should be 22 characters long at maximum."
echo "Enter your username:"
read USERNAME

# check for username
USERNAME_QUERY_RESULT=$($PSQL "SELECT username FROM users WHERE username = '$USERNAME';")

# if new username
if [[ -z $USERNAME_QUERY_RESULT ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."

  # insert user into database
  INSERT_USERNAME_RESULT=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
  USERNAME=$($PSQL "SELECT username FROM users WHERE username = '$USERNAME';")
else
  # Fetch user data
  USERNAME=$($PSQL "SELECT username FROM users WHERE username = '$USERNAME';")
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username = '$USERNAME';")
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username = '$USERNAME';")

  # Greet user with statistics
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

USER_GUESS=0
NUMBER_OF_GUESSES=0
# Guessing game
GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username = '$USERNAME';")
BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username = '$USERNAME';")
GAMES_PLAYED=$(( $GAMES_PLAYED + 1 ))

# Update user's games_played
UPDATE_GAMES_PLAYED_RESULT=$($PSQL "UPDATE users SET games_played = $GAMES_PLAYED WHERE username = '$USERNAME';")

echo "Guess the secret number between 1 and 1000:"

while [[ $USER_GUESS != $SECRET_NUMBER ]]
do
  read USER_GUESS
  NUMBER_OF_GUESSES=$(( $NUMBER_OF_GUESSES + 1 ))

  # Check if guess is an integer
  if [[ ! $USER_GUESS =~ ^[1-9][0-9]*$ ]]
  then
    echo "That is not an integer, guess again:"
    continue
  fi

  if (( USER_GUESS > SECRET_NUMBER ))
  then
    echo "It's lower than that, guess again:"
    continue
  elif (( USER_GUESS < SECRET_NUMBER ))
  then
    echo "It's higher than that, guess again:"
    continue
  else
    # if first game
    if (( BEST_GAME == 0 ))
    then
      UPDATE_BEST_GAME_RESULT=$($PSQL "UPDATE users SET best_game = $NUMBER_OF_GUESSES WHERE username = '$USERNAME';")
    else
      # check if guess_count beats best_game
      if (( NUMBER_OF_GUESSES < BEST_GAME ))
      then
        UPDATE_BEST_GAME_RESULT=$($PSQL "UPDATE users SET best_game = $NUMBER_OF_GUESSES WHERE username = '$USERNAME';")
      fi
    fi
    echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
    break
  fi
done
