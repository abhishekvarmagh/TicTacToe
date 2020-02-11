#! /bin/bash

echo "Welcome to Tic Tac Toe"

#Constant
ROW=3
COLUMN=3
TOTAL_MOVE=$(( ROW*COLUMN ))

declare -A board

#Variables
moveCount=0
playerTurn=false

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
		elif [[ ${board[$(( i-i )),$i]} == $1 && ${board[$(( i+1-i )),$i]} == $1 && ${board[$(( i+2-i )),$i]} == $1 ]]
		then
			win=1
		elif [[ $i -eq 0 && ${board[$i,$i]} == $1 && ${board[$(( i+1 )),$(( i+1 ))]} == $1 && ${board[$(( i+2 )),$(( i+2 ))]} == $1 ]]
		then
			win=1
		elif [[ ${board[0,2]} == $1 && ${board[1,1]} == $1 && ${board[2,0]} == $1 ]]
		then
			win=1
		fi
	done
}

#Check if you can win
function playToWin()
{
	flag=1
	if [ $moveCount -gt 3 ]
	then
		for (( row=0; row<$ROW; row++ ))
		do
			for (( column=0; column<$COLUMN; column++ ))
			do
				if [[ ${board[$row,$column]} == "-" ]]
				then
					board[$row,$column]=$1
					checkWin $1
					if [[ $win -eq 1 ]]
					then
						displayBoard
						echo "Win"
						exit
					else
						board[$row,$column]="-"
					fi
				fi
			done
		done
	fi
}

#Check if you can block the opponent
function checkToBlock()
{
	for (( row=0; row<$ROW; row++ ))
	 do
		for (( column=0; column<$COLUMN; column++ ))
		do
			if [[ ${board[$row,$column]} == "-" ]]
			then
				board[$row,$column]=$1
				checkWin $1
				if [ $win -eq 1 ]
				then
					board[$row,$column]=$computerSymbol
					displayBoard
					moveCount=$(( moveCount+1 ))
					win=0
					flag=0
					return
				else
					board[$row,$column]="-"
				fi
			fi
		done
	done
}

#Occupying the available corner, center or sides 
function setCornerCenterOrSides()
{
	local row=$1
	local column=$2
	local letter=$3
	if [[ ${board[$row,$column]} == "-" ]]
	then
		board[$row,$column]=$letter
		displayBoard
		moveCount=$(( moveCount+1 ))
		playerTurn=true
		switchPlayer
	fi
}

#Check if neither one is winning then try to occupy corners, center or sides
function takeAvailableCornersCenterOrSides()
{
	if [ $flag -eq 1 ]
	then
		for (( i=0; i<$ROW; i=$(( i+ROW-1 )) ))
		do
			for (( j=0; j<$COLUMN; j=$(( j+COLUMN-1 )) ))
			do
				setCornerCenterOrSides $i $j $computerSymbol
			done
		done
		setCornerCenterOrSides $(( ROW/2 )) $(( COLUMN/2 )) $computerSymbol
		for (( i=0; i<$ROW; i++ ))
		do
			for (( j=0; j<$COLUMN; j++ ))
			do
				setCornerCenterOrSides $i $j $computerSymbol
			done
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
		if [[ $rowNumber -gt 2 ]]
		then
			echo "Invalid row"
			switchPlayer
		elif [[ $columnNumber -gt 2 ]]
		then
			echo "Invalid column"
			switchPlayer
		fi
		isEmpty $rowNumber $columnNumber $playerSymbol
		checkWin $playerSymbol
		playerTurn=false
	else
		echo "Machine Turn"
		playToWin $computerSymbol
		checkToBlock $playerSymbol
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
