#! /bin/bash

echo "Welcome to Tic Tac Toe"

#Constant
ROW=3
COLUMN=3
TOTAL_MOVE=$(( ROW*COLUMN ))

declare -A board

moveCount=0
playerTurn=false
flag=1

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

#Assigning Symbol To Players And Toss To Who Will Play First
function assignSymbolAndToss()
{
	if [ $(( RANDOM%2 )) -eq 1 ]
	then
		assignedSymbol x o
		playerTurn=true
	else
		assignedSymbol o x
	fi
	echo "Assigned Symbol to Player is : " $playerSymbol
}

#Assigned Symbol To Palyers
function assignedSymbol
{
	playerSymbol=$1
	computerSymbol=$2
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
		switchPlayer
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

}

#Check either if you can win or play to block opponent
function playToWinAndCheckToBlock()
{
	flag=1
	for (( row=0; row<$ROW; row++ ))
	do
		for (( column=0; column<$COLUMN; column++ ))
		do
			if [[ ${board[$row,$column]} == "-" ]]
			then
				board[$row,$column]=$1
				checkWin $1
				if [ $win -eq 0 ]
				then
					board[$row,$column]="-"
				elif [[ $win -eq 1 && ${board[$row,$column]} == $computerSymbol ]]
				then
					displayBoard
					echo "Win"
					exit
				elif [ $win -eq 1 ]
				then
					board[$row,$column]=$computerSymbol
					displayBoard
					win=0
					moveCount=$(( moveCount+1 ))
					flag=0
					break
				fi
			fi
		done
		if [ $flag -eq 0 ]
		then
			break
		fi
	done
}

#Check if neither one is winning then try to occupy corners, center or sides
function takeAvailableCornersCenterOrSides()
{
	if [ $flag -eq 1 ]
	then
		for (( i=0; i<$ROW; i=$(( i+2 )) ))
		do
			for (( j=0; j<$COLUMN; j=$(( j+2 )) ))
			do
				if [[ ${board[$i,$j]} == "-" ]]
				then
					board[$i,$j]=$computerSymbol
					displayBoard
					moveCount=$(( moveCount+1 ))
					flag=0
					break
				fi
			done
			if [ $flag -eq 0 ]
			then
				break
			fi
		done
	fi
	if [ $flag -eq 1 ]
	then
		if [[ ${board[1,1]} == "-" ]]
		then
			board[1,1]=$computerSymbol
			displayBoard
			moveCount=$(( moveCount+1 ))
			flag=0
		fi
	fi
	if [ $flag -eq 1 ]
	then
		for (( i=0; i<$ROW; i=$(( i+2 )) ))
		do
			j=1
			if [[ ${board[$i,$j]} == "-" ]]
			then
				board[$i,$j]=$computerSymbol
				displayBoard
				moveCount=$(( moveCount+1 ))
				break
			elif [[ ${board[$j,$i]} == "-" ]]
			then
				board[$j,$i]=$computerSymbol
				displayBoard
				moveCount=$(( moveCount+1 ))
				break
			fi
		done
	fi
}

#Switching Player Function
function switchPlayer()
{
while [ $moveCount -ne $TOTAL_MOVE ]
do
	if [[ $playerTurn == true ]]
	then
		read -p "Enter row (0-2) and column (0-2) number : " rowNumber columnNumber
		if [[ $rowNumber -gt 2 || $columnNumber -gt 2 ]]
		then
			echo "Invalid row or column number entered"
			switchPlayer
		fi
		isEmpty $rowNumber $columnNumber $playerSymbol
		playerTurn=false
	else
		echo "Machine Turn"
		playToWinAndCheckToBlock $computerSymbol
		playToWinAndCheckToBlock $playerSymbol
		takeAvailableCornersCenterOrSides $computerSymbol
		playerTurn=true
	fi
	if [ $win -eq 1 ]
	then
		echo "Win"
		exit
	fi
done
}

resetBoard
assignSymbolAndToss
displayBoard
switchPlayer
echo "Tie"
