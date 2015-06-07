# McAfee-Agent
This script can be used to either freshly install or upgrade the ePo agent on OS X clients.

What you do is install the McAfee install.sh to /Library/Application Support/McAfee/ and then the script runs from there. There is autodetect code to see if the agent is already in place, in which case the script initiates an upgrade. Otherwise it'll commmand the install.sh script to do a fresh install.
