#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
$PSQL "TRUNCATE TABLE games, teams";
$PSQL "ALTER SEQUENCE games_game_id_seq RESTART WITH 1";
$PSQL "ALTER SEQUENCE teams_team_id_seq RESTART WITH 1";

file="games.csv"
while IFS=',' read -r year round winner opponent winner_goals opponent_goals;
do
if [ $year != 'year' ]
then
winner_exist_result=$($PSQL "SELECT * FROM teams WHERE name = '$winner'")

if [ -z "$winner_exist_result" ]
then
$PSQL "INSERT INTO teams(name) VALUES ('$winner')";
fi
opponent_exist_result=$($PSQL "SELECT * FROM teams WHERE name = '$opponent'")
if [ -z "$opponent_exist_result" ]
then 

$PSQL "INSERT INTO teams(name) VALUES ('$opponent')";
fi

fi
done < "$file"

while IFS=',' read -r year round winner opponent winner_goals opponent_goals;
do
if [ $year != 'year' ]
then

winner_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner'")
opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent'")
$PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals )";

fi
done < "$file"

# Do not change code above this line. Use the PSQL variable above to query your database.
