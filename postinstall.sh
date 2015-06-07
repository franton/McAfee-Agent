#!/bin/bash

# Script to install latest McAfee version from install.sh script.
# Should also upgrade any previous software before proceeding.

# Author  : contact@richard-purves.com
# Version : 1.0 - Initial Version

# Set up log file, folder and function
LOGFOLDER="/var/log/organisation"
LOG=$LOGFOLDER"/McAfee-Install.log"

if [ ! -d "$LOGFOLDER" ];
then
	mkdir $LOGFOLDER
fi

echo $( date )" - Starting installation of McAfee Agent" > $LOG

logme()
{
	# Check to see if function has been called correctly
	if [ -z "$1" ]
	then
		echo $( date )" - logme function call error: no text passed to function! Please recheck code!"
		exit 1
	fi

	# Log the passed details
	echo "" >> $LOG
	echo $( date )" - "$1 >> $LOG
	echo "" >> $LOG
}

# Check for existing McAfee agent. Upgrade if present. Full install if not.

if [ -d "/Library/McAfee/cma/" ]
then
	logme "Existing installation detected. Upgrading."
	/Library/Application\ Support/McAfee/install.sh -u 2>&1 | tee -a ${LOG}
else
	logme " - Installing new McAfee Agent"
	/Library/Application\ Support/McAfee/install.sh -i 2>&1 | tee -a ${LOG}
fi

# Now make the agent check for policies and other tasks

logme "Checking for new policies"
/Library/McAfee/agent/bin/cmdagent -c 2>&1 | tee -a ${LOG}

logme "Collecting and sending computer properties to ePO server"
/Library/McAfee/agent/bin/cmdagent -p 2>&1 | tee -a ${LOG}

logme "Forwarding events to ePO server"
/Library/McAfee/agent/bin/cmdagent -f 2>&1 | tee -a ${LOG}

logme "Enforcing ePO server policies"
/Library/McAfee/agent/bin/cmdagent -e 2>&1 | tee -a ${LOG}

# All done!

logme "Installation script completed"
