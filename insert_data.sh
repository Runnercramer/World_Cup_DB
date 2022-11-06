#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

echo $($PSQL "TRUNCATE games, teams")
# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")

    if [[ -z $TEAM_ID ]]
    then
      INSERT_TEAM_ID_RESULT_WINNER=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")
        if [[ $INSERT_TEAM_ID_RESULT_WINNER == "INSERT 0 1" ]]
        then
          echo Inserted into teams $WINNER winner team
        fi
    fi

    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

    if [[ -z $TEAM_ID ]]
    then
      INSERT_TEAM_ID_RESULT_OPPONENT=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")
        if [[ $INSERT_TEAM_ID_RESULT_OPPONENT == "INSERT 0 1" ]]
        then
          echo Inserted into teams $OPPONENT opponent team
        fi
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
    then
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
      INSERT_GAME_RESULT=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
      if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
        then
          echo Inserted game between $WINNER and $OPPONENT
        fi
    fi
done
