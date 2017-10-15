#!/bin/bash
shortdate=$(date +"%Y-%m-%d")
longdate=$(date)
argprefDeleteSaved="n"
argprefUseSaved=""
argLFTPFlags="set ftp:ssl-allow no; mirror --use-pget-n=5 --parallel=5 --only-missing --allow-chown"
usrlocaldir=$(pwd)
usrlocalown=$()
#argMigrationTime=""

# Check LFTP is installed
command -v lftp >/dev/null 2>&1 || { echo >&2 "I require LFTP but it's not installed.  Aborting."; exit 1; }
printf "LFTP appears to be installed, moving on...\n"
sleep 2

# Check for .danftp.save in current directory
if [ -f ".danftp.save" ]; then
  # Print the saved values to the screen then ask if they are to be used
  argMigrationTime=$(grep migrationtime .danftp.save | cut -d " " -f 2-);
  usrftpserver=$(grep server .danftp.save | cut -d " " -f 2);
  usrftpusername=$(grep username .danftp.save | cut -d " " -f 2);
  usrftppassword=$(grep password .danftp.save | cut -d " " -f 2);
  usrftpremotedir=$(grep remotedir .danftp.save | cut -d " " -f 2);
  #
  printf "Detected a previous migration (.ftp-migration.save):\n"
  printf "+--------------+--------------+--------------+--------------+\n"
  printf "+\n"
  printf "+ Migration Date: $argMigrationTime\n"
  printf "+ Server:         $usrftpserver\n"
  printf "+ Username:       $usrftpusername\n"
  printf "+ Password:       $usrftppassword\n"
  printf "+ Remote Dir:     $usrftpremotedir\n"
  printf "+ Local  Dir:     $usrlocaldir\n"
  printf "+ Local Owner:    $usrlocalown\n"
  printf "+\n"
  printf "+--------------+--------------+--------------+--------------+\n"
  read -p "Do you want to use the same details? [y/n] "
    if [[ ${REPLY,,} =~ ^y ]]; then
      # Uses the sames details
      printf "Moving on ...\n"
      sleep 1
    else
      sleep 1
      # Enter new server details so they can be saved to .danftp.save
      printf "Enter the server details:\n"
      read -p "Server: " usrftpserver
      read -p "Username: " usrftpusername
      read -p "Password: " usrftppassword
      read -p "Remote Directory: " usrftpremotedir
      sleep 1
    fi
else
  printf "No previous migration detected, moving on ...\n"
  sleep 1
  # Enter new server details so they can be saved to .danftp.save
  printf "Enter the server details:\n"
  read -p "Server: " usrftpserver
  read -p "Username: " usrftpusername
  read -p "Password: " usrftppassword
  read -p "Remote Directory: " usrftpremotedir
  sleep 1
fi

# Seeing if server details are to be saved
read -p "Save details for next time? [y/n] "
if [[ ${REPLY,,} =~ ^y ]]; then
  printf "Saving details to '.danftp' ...\n"
  touch .danftp.save
  echo "server $usrftpserver" > .danftp.save
  echo "username $usrftpusername" >> .danftp.save
  echo "password $usrftppassword" >> .danftp.save
  echo "remotedir $usrftpremotedir" >> .danftp.save
  sleep 1
else
  printf "No details saved to disk, moving on ...\n"
  sleep 3
fi

printf "Starting LFTP and beginning sync of files using:\n"
sed -i '/migrationtime/d' .danftp.save
echo "migrationtime $longdate" >> .danftp.save
echo "Start time: $longdate"
echo "Server: $usrftpserver"
echo "Username: $usrftpusername"
echo "Password $usrftppassword"
echo "Remotedir: $usrftpremotedir"

# Perform the file sync according to arguments above
lftp ftp://$usrftpusername:$usrftppassword@$usrftpserver -e "$argLFTPFlags  $usrftpremotedir; quit"

# Refresh the time
longdate=$(date)

echo "Sync completed."
echo "finishtime $longdate" >> .danftp.save
echo "Finish time: $longdate"
