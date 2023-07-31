# Background Automatic Directory Backup Using Cronjob
## _Description_
This background running program offers a safe way of backing up a certain directory to another backup directory upon a change is detected.
## _How it works?_
The user provides the program with 4 parameters:
- Name of directory to be Backed up.
- Name of directory to ahich the backup will be stored.
- Maximum number of backups stored in given backup directory.

Upon adding the cronjob to the crontab, the program is automatically executed on the defined time the user pre-defined in the cronjob.
When the program is run, a backup for the target directory is stored in the backup directory _(pre-defined by the user in the crontab)_ and the target directory's info is saved for future scans. 

Then, at everytime the program is run a scan for changes is made to check if the directory was changed,
- If a change is detected; a copy of the directory renamed to the date and time fo backup is stored in the backup directory, and new directory info is stored for future checking ofr changes.
Then, if the number of backups stored in the backup directory exceeds the maximum number of backups _(predefined by the user in the crontab)_, only the most recent number _(check note)_ of backups are stored and all other older backups are deleted.
_Note: The number of backups not deleted (kept stored) is the maximum number of backups given by the user in the crontab_

- Else if no change is detected, no backup will be stored as it would be a duplicate for another backup in the same backup directory therefore offering better memory management by the program.

## _How to use?_
First, The user should make sure that _make_ is installed on the system by typing this command in the terminal:
```sh
man make
```
If it is not installed, the user should install it by typing the next command:
```sh
sudo apt install make
```
Then, the user should open the terminal, and type the following command:
```sh
crontab -e
```
This command will open the crontab where the user will store his cronjob which will be executed automatically in the background, the user should type the following command in the crontab:
```sh
* * * * * cd path && make directory=dir backup=backupdir max=5
```
- path: The path of the folder where the Makefile and the target directory exist.
- directory= The target directory to be backed up.
- backup= The backup directory name where backups will be stored.
- max= The maximum number of backups to be stored in the backup directory.

### Note:
- The next diagram illustrates how to define when should the cronjob run.
This link should make it easier for the user to define the timing:
https://crontab.guru/
```sh
*   *   *   *   *  sh /path/to/script/script.sh
|   |   |   |   |              |
|   |   |   |   |      Command or Script to Execute        
|   |   |   |   |
|   |   |   |   |
|   |   |   |   |
|   |   |   | Day of the Week(0-6)
|   |   |   |
|   |   | Month of the Year(1-12)
|   |   |
|   | Day of the Month(1-31)  
|   |
| Hour(0-23)  
|
Min(0-59)
```
- If the user wants to run the program every third Friday of the month, the user should uncomment lines from 8 to 12 and change the cronjob to the following:
```sh
* * * * 5 sh /path/to/script/script.sh
```
## Input Restrictions:
- Number of arguments must be valid.
- If Target Directory does not exist, wrong name, any other user-error, the program will exit and the backup will not be stored.
- Maximum number of backups  must be a non-negtive integer, otherwise the program will exit and the backup will not be stored.
## Warnings:
- If the backup directory given by the user originally have other directories they are at risk of being deleted by the program. Therefore, The user should make sure to give an empty directory or give a name of a non-existing directory and the program will create a new empty one.
# Author: Aly Hamdy Ibrahim Hassan