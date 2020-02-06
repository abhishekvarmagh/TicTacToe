#! /bin/bash

echo "Welcome to Tic Tac Toe"

#Constant
ROW=3
COLUMN=3
TOTAL_MOVE=$(( ROW*COLUMN ))

declare -A board

moveCount=0

#Resetting the board
function resetBoard()
{
	for (( i=0; i<$ROW; i++ ))
	do
   	for (( j=0; j<$COLUMN; j++ ))
   	do
      	board[$i,$j]="-"
   	done
	done
}

#Assigning Symbol To Player
function assignSymbolAndToss()
{
	if [ $(( RANDOM%2 )) -eq 1 ]
	then
		playerSymbol=x
		playerTurn=true
	else
		playerSymbol=o
		playerTurn=true
	fi
	echo "Assigned Symbol to Player is : " $playerSymbol
}

#Display Board
function displayBoard()
{
	for (( i=0; i<$ROW; i++ ))
	do
		for (( j=0; j<$COLUMN; j++ ))
		do
			echo -e "| ${board[$i,$j]} | \c"
		done
		echo
	done
}

#To check whether cell is occupied or not
function isEmpty()
{
	row=$1
	column=$2
	letter=$3
	if [[ ${board[$row,$column]} == "-" ]]
	then
		board[$row,$column]=$letter
		moveCount=$(( moveCount+1 ))
	else
		echo "cell already occupied"
	fi
}

resetBoard
assignSymbolAndToss
displayBoard

while [ $moveCount -ne $TOTAL_MOVE ]
do
	if [[ $playerTurn == true ]]
	then
		read -p "Enter row and column number : " rowNumber columnNumber
		isEmpty $rowNumber $columnNumber $playerSymbol
	fi
	displayBoard
done
