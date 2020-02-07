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
	local row=$1
	local column=$2
	local letter=$3
	if [[ ${board[$row,$column]} == "-" ]]
	then
		board[$row,$column]=$letter
		displayBoard
		moveCount=$(( moveCount+1 ))
		checkWin $letter
	else
		echo "cell already occupied"
	fi
}

#Checking All Winning Condition
function checkWin()
{
	win=0
	for (( i=0; i<$ROW; i++ ))
	do
		if [[ ${board[$i,$(( i-i ))]} == $1 && ${board[$i,$(( i+1-i ))]} == $1 && ${board[$i,$(( i+2-i))]} == $1 ]]
		then
			win=1
		fi
		if [[ ${board[$(( i-i )),$i]} == $1 && ${board[$(( i+1-i )),$i]} == $1 && ${board[$(( i+2-i )),$i]} == $1 ]]
		then
			win=1
		fi
	done

	if [[ ${board[0,0]} == $1 && ${board[1,1]} == $1 && ${board[2,2]} == $1 ]]
	then
		win=1
	fi
	if [[ ${board[0,2]} == $1 && ${board[1,1]} == $1 && ${board[2,0]} == $1 ]]
	then
		win=1
	fi

	if [ $win -eq 1 ]
	then
		echo "Win"
		exit
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
done
