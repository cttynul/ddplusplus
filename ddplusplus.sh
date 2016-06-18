#!bin/bash
# dd++ makes using dd easier
# it displays a progress bar in terminal or dialog mode
# published under GNU GPLv3
# cttynul.ml

# check $1 and $2
if [ $# -ne 2 ]
then
	echo "Usage: $0 input output"
	exit 1
fi

# check if root
if [ $EUID -ne 0 ] 
then
	echo "You must be root to run this" 1>&2
	exit 1
fi

# check if pv is installed
if which pv >/dev/null 
then
	if which dialog >/dev/null
	then
		(pv -n $1 | dd of=$2 bs=128M conv=notrunc,noerror) 2>&1 | dialog --title "Running dd++" --gauge "dd++ is cloning $1 into $2. Please wait..." 10 70 0
	
	else
		echo "dd++ is cloning $1 into $2. Please wait..."		
		pv -tpreb $1 | dd of=$2 bs=4096 conv=notrunc,noerror
	fi	
else
	echo "pv is not installed, need it to run $0"
	exit 1
fi

