#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  echo "$YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS"

  if [[ $WINNER != 'winner' ]]
  then
    WINNER_PRESENCE=$($PSQL "SELECT name FROM teams WHERE name='$WINNER' ")
    OPPONENT_PRESENCE=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT' ")

    if [[ -z $WINNER_PRESENCE ]]
    then
      ADDING_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi

    if [[ -z $OPPONENT_PRESENCE ]]
    then
      ADDING_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    ADDING_GAMES=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
  fi
done
