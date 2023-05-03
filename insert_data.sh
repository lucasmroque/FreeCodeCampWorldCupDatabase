#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS

do
  #get all countries from winner column
  if [[ $WINNER != "winner" ]]
  then
    #get winner name
    #fist step is to check if the WINNER NAME is already on the table - If not, it's added
    #the query below is searching for a name (or team_id) on the teams table that is equal to the one assigned to the $WINNER variable
    WINNER_NAME=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #if WINNER_NAME is empty, then add the name to the table teams
    #the attribute "-z" returns true if the variable is empty
    #if not found:
    if [[ -z $WINNER_NAME ]]
    then
      #insert the winner name on the table teams, column name
      INSERT_WINNER_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      
      #get the new WINNER_NAME
      WINNER_NAME=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
  fi

  #get all countries from opponent column
  if [[ $OPPONENT != "opponent" ]]
  then
    #get winner name
    #fist step is to check if the OPPONENT NAME is already on the table - If not, it's added
    #the query below is searching for a name (or team_id) on the teams table that is equal to the one assigned to the $OPPONENT variable
    OPPONENT_NAME=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #if WINNER_NAME is empty, then add the name to the table teams
    #the attribute "-z" returns true if the variable is empty
    #if not found:
    if [[ -z $OPPONENT_NAME ]]
    then
      #insert the opponent name on the table teams, column name
      INSERT_OPPONENT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

      #get the new WINNER_NAME
      OPPONENT_NAME=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
  fi

done

#reading the csv again, now the teams table is populated
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS

do
  #add all info from games.csv to games table, including the ids from each team
  if [[ $YEAR != "year" ]]
  then
    WINNER_NO=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_NO=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    INSERT_GAMEINFO=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES('$YEAR','$ROUND','$WINNER_NO','$OPPONENT_NO','$WGOALS','$OGOALS')")
  fi
done
