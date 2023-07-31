#! /bin/bash
#----------don't remove the comments before reading the README file----------
# the commented part from line(8) till line(12) is added so if the user wants the code to be run
# only on the third (day of the week) of every month, the exact day of the week is defind by the
# user in the crontab: ex: for the code to be run every third Friday in the month:
# * * * * 5 sh /path/to/script/script.sh
#----------------------------------------------------------------------------
#day=$(date '+%d')
#if ! [[ ${day} -ge 15 && ${day} -le 21 ]]
#then
#	exit
#fi
#----------storing arguments in array----------
args=("$@")
#----------Validating number of arguments---------
if ! [ ${#args[@]} -eq 3 ]
then
	echo "non-valid number of arguments"
	exit
fi
#----------Validating existence of target directory----------
if ! [ -d ${args[0]} ]	
then
	echo "non-valid directory"
	exit
fi
#----------Validating number of maximum backups----------
regex='^[1-9]+$'
if ! [[ ${args[2]} =~ $regex ]]
then
	echo "non-valid number"
	exit
fi
#----------checking if it's the first time to run----------
# if statement will be executed if no direcotry-info.last is found
# this means that this is the first time the script is being executed
# the directory-info.last will be saved and a backup will be stored
# then the script will exit
if ! [ -f directory-info.last ]
then
	echo "first time to run"
	ls -lR ${args[0]} > directory-info.last
	cp -R ${args[0]} ${args[1]}
	date=$(date '+%Y-%m-%d-%H-%M-%S')
	mv ./${args[1]}/${args[0]} ./${args[1]}/${date}
	echo "BACKUP STORED: ./${args[1]}/${date}"
	exit
fi
#----------saving directory's new info----------
ls -lR ${args[0]} > directory-info.new
new=$(cat directory-info.new)
last=$(cat directory-info.last)
#----------comparing directory's old and latest info ----------
echo -n "SCAN RESULT: "
if [[ $last == $new ]]
then #----------no change in directory detected----------
	echo "NO CHANGE DETECTED IN TARGET DIRECTORY"
else #----------change in directory detected----------
	echo "CHANGE DETECTED IN TARGET DIRECTORY"
	#----------saving the new directory info----------
	ls -lR ${args[0]} > directory-info.last
	#----------backing up and renaming----------
	cp -R -p ${args[0]} ${args[1]}
	date=$(date '+%Y-%m-%d-%H-%M-%S')
	mv ./${args[1]}/${args[0]} ./${args[1]}/${date}
	echo "BACKUP STORED: ./${args[1]}/${date}"
	#----------checking if max number of backups reached----------
	x=$(find ./${args[1]} -mindepth 1 -maxdepth 1 -type d | wc -l) #fetching number of files in backup directory
	if [ $x -gt ${args[2]} ] #if num of backups has exceeded the max num
	then	#----------deleteing all backups except the most recent $(max) backups----------
		echo "MAXIMUM NUMBER OF STORED BACKUPS REACHED IN ${args[1]}"
		oldest=$(ls ./backupdir -1t | tail -n +$((${args[2]} + 1)))
		cd ${args[1]}
		rm -r ${oldest}
		cd ..
		echo "BACKUPS DELETED: ${oldest}"
	fi 
fi











