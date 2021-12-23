#!/bin/bash
##################################################
# MIT License
##################################################
# File: setuplinks
# Description: Setup a list of symbolic links
# Author: Pavel Hajek
# License: MIT
# Version: 1.0
##################################################


##################################################
#TODO: Write LoadLists and  read the lists from a file
##################################################

# ===============================	
# FUNCTIONS
# ===============================	

Help()
{
	# Display Help
	echo "NAME:"
	echo "   setuplinks"
	echo "SYNTAX:"
	echo "   setuplinks [-b|d|f|h|i] CONTROLFILE"
	echo "DESCRIPTION:"
	echo "   Creates symbolink links TARGET<-LINKNAME as specified in the"
	echo "   CONTROLFILE in two tab-separated columns. Runs 'ln' in the"
	echo "   interactive mode by default."
	echo "   -b     If LINKNAME exists, it is moved to LINKNAME.bck."
	echo "          If LINKNAME.bck exists, it is moved to LINKNAME.bck~"
	echo "   -d     Dry run."
	echo "   -f     If LINKNAME exists, it is deleted without confirmation." 
	echo "   -h     Prints this help."
	echo "   -i     Asks for confirmation before every file operation."
	echo "   -v     Verbose mode. Prints out every file operation."
	echo "   -s     Silent  mode. Does not print out progress and warnings."
	echo "AUTHOR:"
	echo "   Written by Pavel Hajek."
	echo "COPYRIGHT:"
	echo "   MIT License © 2021 Pavel Hajek" 
}


RunCommand()
{
	if [ $VERBOSE -eq 1 ]; then
		echo "$1"
	fi
	if [ $INTERACTIVE -eq 1 ]; then
		read -p "Press [Yy] to continue: " -n 1 -r
		echo
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			if [ $DRY -eq 0 ]; then
				eval "$1"
			fi
		else
			echo "Skipping."
		fi
	else
		if [ $DRY -eq 0 ]; then
			eval "$1"
		fi
	fi
}

LoadLists()
{
	while IFS=$'\t' read -r COL1 COL2 REM
	do
		if [[ ! "$COL1" =~ \#.* ]]; then 	
			TARGETS+=("$COL1")
			LINKNAMES+=("$COL2")	 
			REMAINDERS+=("$REST")
		fi
	done < $1
}
# ===============================	
# PROCESS OPTIONS
# ===============================	
	DRY=0
	BACKUP=0
	FORCE=0
	INTERACTIVE=0
	VERBOSE=0
	SILENT=0
	while [ -n "$1" ]
	do
		case "$1" in
		-b) BACKUP=1 ;;
		-d) DRY=1 ;;
		-f) FORCE=1 ;;
		-h) 	Help
			exit ;;
		-i) INTERACTIVE=1 ;;
		-v) VERBOSE=1 ;;
		-s) SILENT=1 ;;
		*)  	FILENAME=$1
			shift
			if [ -n "$1" ]; then
				echo "Error: Arguments in wrong format. See help."
				exit -1
			else
			       break
			fi ;;
			
		esac
		shift
	done

# ===============================	
# LOAD LISTS
# ===============================	
  
	if [ ! -n "$FILENAME" ]; then
		echo "Error: Control file not specified. See help."
		exit -1
	fi
	if [ ! -f "$FILENAME" ]; then
		echo "Error: '$FILENAME' does not exist."
		exit -1
	fi

	declare -a LINKNAMES
	declare -a TARGETS
	declare -a REMAINDERS

	LoadLists $FILENAME

	LENLINKNAMES=${#LINKNAMES[@]}
	LENTARGETS=${#TARGETS[@]}

	if [ ! $LENTARGETS -eq $LENLINKNAMES ]; then
		echo "Error: '$FILENAME' has wrong format."
		exit -1	
	fi
# ===============================	
# MAIN
# ===============================	
	for ((i = 0 ; i < $LENTARGETS ; i++)); do
		if [ -f "${TARGETS[$i]}" ] || [ -d "${TARGETS[$i]}" ]; then
			if [ -f "${LINKNAMES[$i]}" ] || [ -d "${LINKNAMES[$i]}" ]; then 
				if [ $BACKUP -eq 1 ]; then
					if [ ! $SILENT -eq 1 ]; then
						echo "Backing up ${LINKNAMES[$i]}."
					fi
					RunCommand "mv -b '${LINKNAMES[$i]}' '${LINKNAMES[$i]}.bck'"
				fi		
			fi
			if [ ! $SILENT -eq 1 ]; then
				echo "Creating symbolic link ${LINKNAMES[$i]} with target ${TARGETS[$i]}"
			fi		
			if [ $FORCE -eq 1 ]; then
				RunCommand "ln -n -f -s '${TARGETS[$i]}' '${LINKNAMES[$i]}'"	
			else
				RunCommand "ln -n -i -s '${TARGETS[$i]}' '${LINKNAMES[$i]}'"	
			fi
		else
			if [ ! $SILENT -eq 1 ]; then
				echo "File or directory '${TARGETS[$i]}' does not exist. Skipping."
			fi
		fi
	done
	exit 0
