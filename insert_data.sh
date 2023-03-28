#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "truncate teams, games") #Clear data from table

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Exclude headers
  if [[ $WINNER != "winner" ]]
  then
    #Get team name
    WINNER_NAME=$($PSQL"SELECT name FROM teams WHERE name='$WINNER'")
    #If not found then enter team into table
    if [[ -z $WINNER_NAME ]]
    then
      INSERT_WINNER_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      #Print when data entered
      if [[ $INSERT_WINNER_NAME == "INSERT 0 1" ]]
      then
        echo entered $WINNER
      fi
    fi    
  fi

  #Exclude headers
  if [[ $OPPONENT != "opponent" ]]
  then
  #Get team name
    OPPONENT_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    #If not found then enter team into table
    if [[ -z $OPPONENT_NAME ]]
    then
      INSERT_OPPONENT_NAME=$($PSQL "INSERT INTO teamS(name) VALUES('$OPPONENT')")
      #Print when data entered
      if [[ $INSERT_OPPONENT_NAME == "INSERT 0 1" ]]
      then
        echo entered $OPPONENT into teams table.
      fi  
    fi
  fi

  if [[ $YEAR != "year" ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    INSERT_GAME_DATA=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAME_DATA == 'INSERT 0 1' ]]
    then
     echo Game entered: $WINNER $WINNER_GOALS - $OPPONENT_GOALS $OPPONENT. $ROUND from $YEAR World Cup.
    fi
  fi
  done