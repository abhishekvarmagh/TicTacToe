#! /bin/bash

echo "Welcome to Tic Tac Toe"

#Constant
ROW=3
COLUMN=3

declare -A board

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

resetBoard
assignSymbolAndToss
