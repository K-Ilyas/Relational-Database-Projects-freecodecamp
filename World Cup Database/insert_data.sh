#! /bin/bash

if [[ $1 == "test" ]]; then
    PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
    PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS; do
    if [[ $YEAR != 'year' ]]; then
        # ignore first row

        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

        # WINNER teams
        if [[ -z $WINNER_ID ]]; then
            INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
            if [[ $INSERT_TEAM == 'INSERT 0 1' ]]; then
                echo Insert team : $WINNER
                WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
            fi
        fi
        # opponet teams

        if [[ -z $OPPONENT_ID ]]; then
            INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
            if [[ $INSERT_TEAM == 'INSERT 0 1' ]]; then
                echo Insert team : $OPPONENT
                OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
            fi
        fi

        #insert rows in games

        INSERT_GAME=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
        if [[ $INSERT_GAME == 'INSERT 0 1' ]]; then
            echo Insert game : $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS
        fi

    fi

done
