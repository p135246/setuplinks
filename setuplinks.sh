#!/bin/bash
##################################################
# MIT License
##################################################
# File: setuplinks
# Description: Sets up a list of symbolic links
# Author: Pavel Hajek
# License: MIT
# Version: 1.1
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
	echo "   setuplinks [-b|d|f|h|i|r|s|v] FILE"
	echo "DESCRIPTION:"
	echo "   Creates a symbolink link LINKNAME->TARGET for each line of FILE"
	echo "   in the form 'LINKNAME;TARGET'. Only lines starting with '#' are ignored."
	echo "   By default, the interactive mode of 'ln' is invoked (asks before"
	echo "   replacement) and the progress is printed."
	echo "MODIFIERS:"
	echo "   -b     Backup: If LINKNAME exists, it is moved to LINKNAME.bck"
	echo "          (in the same folder)."
	echo "   -d     Dry run: Does not make any changes on files."
	echo "   -f     Non-interactive mode of 'ln': If LINKNAME exists, it is"
	echo "          deleted without confirmation."
	echo "   -h     Prints this help."
	echo "   -i     Interactive mode: Requires confirmation of every file operation."
	echo "   -r     Restore: If LINKNAME.bck exists, it is switched with LINKNAME."
	echo "   -s     Silent  mode: Does not print out any progress."
	echo "   -v     Verbose mode: Prints out each file-command."
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
			CONTINUE=1
		else
			CONTINUE=0
		fi
	fi
	if [ $DRY -eq 0 ]; then
		CONTINUE=1
	else
		CONTINUE=0
	fi
	if [ $CONTINUE -eq 1 ]; then	
		eval "$1"
	else
		echo "Skipping."
	fi
}

LoadLists()
{
	while IFS=$';' read -r COL1 COL2 REM
	do
		if [[ ! "$COL1" =~ \#.* ]]; then 	
			TARGETS+=("`eval echo $COL2`")
			LINKNAMES+=("`eval echo $COL1`")
			REMAINDERS+=("$REST")
		fi
	done < $1
}

Message()
{
	if [ ! $SILENT -eq 1 ]; then
		echo $1
	fi
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
	REVERT=0
	while [ -n "$1" ]
	do
		case "$1" in
		-b) BACKUP=1 ;;
		-d) DRY=1 ;;
		-f) FORCE=1 ;;
		-h) 	Help
			exit ;;
		-i) INTERACTIVE=1 ;;
		-r) REVERT=1 ;;
		-s) SILENT=1 ;;
		-v) VERBOSE=1 ;;
		*)  FILENAME=`eval echo $1`
			shift
			if [ -n "$1" ]; then
				echo "Error: Arguments in wrong format. Run with -h for help."
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
		echo "Error: Control file not specified. Run with -h for help."
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
		echo "Error: '$FILENAME' has wrong format. Run with -h for help."
		exit -1	
	fi
# ===============================	
# MAIN
# ===============================
	if [ $REVERT -eq 1 ]; then
		for ((i = 0 ; i < $LENTARGETS ; i++)); do
			if [ -f "${LINKNAMES[$i]}.bck" ] || [ -d "${LINKNAMES[$i]}.bck" ]; then
				Message "Swapping ${LINKNAMES[$i]} and ${LINKNAMES[$i]}.bck."
				RANDSTRING=$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 20)
				RunCommand "mv '${LINKNAMES[$i]}' '/tmp/$RANDSTRING'; mv '${LINKNAMES[$i]}.bck' '${LINKNAMES[$i]}'; mv '/tmp/$RANDSTRING' '${LINKNAMES[$i]}.bck'"
			else
				Message "Backup ${LINKNAMES[$i]}.bck does not exist. Skipping."
			fi
		done
		exit
	fi
	for ((i = 0 ; i < $LENTARGETS ; i++)); do
		if [ -f "${TARGETS[$i]}" ] || [ -d "${TARGETS[$i]}" ]; then
			if [ -f "${LINKNAMES[$i]}" ] || [ -d "${LINKNAMES[$i]}" ]; then
				if [ $BACKUP -eq 1 ]; then
					Message "Backing up ${LINKNAMES[$i]} to ${LINKNAMES[$i]}.bck"
					if [ -f "${LINKNAMES[$i]}.bck" ] || [ -d "${LINKNAMES[$i]}.bck" ]; then
					    Message "- Making space by moving ${LINKNAMES[$i]}.bck to /tmp/"
					    RANDSTRING=$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 20)
						RunCommand "mv '${LINKNAMES[$i]}.bck' '/tmp/$RANDSTRING'"
					fi
					Message "- Moving ${LINKNAMES[$i]} to ${LINKNAMES[$i]}.bck"
					RunCommand "mv '${LINKNAMES[$i]}' '${LINKNAMES[$i]}.bck'"
				fi
			fi
			Message "Creating symbolic link ${LINKNAMES[$i]} with target ${TARGETS[$i]}"
			mkdir -p "$(dirname ${LINKNAMES[$i]})"
			if [ $FORCE -eq 1 ]; then
				RunCommand "ln -n -f -s '${TARGETS[$i]}' '${LINKNAMES[$i]}'"	
			else
				RunCommand "ln -n -i -s '${TARGETS[$i]}' '${LINKNAMES[$i]}'"	
			fi
		else
			Message "File or directory '${TARGETS[$i]}' does not exist. Skipping."
		fi
	done
	exit 0
