target_cron:
	@mkdir -p $(backup)	#creating backup directory if there does not exist any backup directory with the given name
	@./backup-cron.sh $(directory) $(backup) $(max) #executing backup-cron bash script
