# danFTP
> "An almost fully automatic FTP based website migrating tool"

#### What does this mean?
* Requires only 1 package to operate -- lftp, which is available in all standard repos without additional modification
* Requires only FTP access to a remote server to operate successfully
* Operates like rsync in that it syncs remote-local in an incremental fashion very quickly, downloading only new or updated files.
* Native functionality to re-run a previous migration again if you need to update the local file system.

#### What is this for?
* You're tasked with migrating a website from a remote web-server where the only login you have been provided is some FTP credentials; no SSH, no control panel, nothing.
* You need an easily scripted method of transferring content between a development and production server
* You're conducting a manual mail migration between 2 IMAP servers and require new emails pulled down whilst DNS changes, so as not to hinder users in the changeover period.
* You're conducting many migrations between servers concurrently and don't want to get confused about which server you're working on at any given time.

----

## How to use
1. Ensure you're logged in as root or have sudo privileges
2. Clone the repository to any directory on the server
3. Ensure danftp.sh is executable; `chmod +x danftp.sh`
3. Move danftp.sh into your path for easier access; `mv danftp.sh /usr/bin/danftp`.
4. Navigate to a directory where you need to download files to then run `danftp`.
5. If a previous migration cannot be found you'll be prompted to provide some credentials and a server.
   * If a previous migration is found, you'll be prompted if you wish to use the same credentials (re-syncing the data).
6. Either option will ask you if you wish to save the details for next time.
7. The script with then execute, first scanning to see what files need to be downloaded then doing so and giving you a brief output.
   * The script follows symlinks, ensuring file structures remain intact.
   * The script downloads 5 files at a time, using 5 connections per file to ensure speed is maximised.
   * All downloads are set to inherit the ownership of the parent directory (useful in a shared or multi-tenanted environment).
8. The credentials chosen are saved to `.danftp.save` in the parent directory, which is re-used on consecutive runs.

## Use cases
* cPanel Shared Server - navigate to the users home directory then run, all files are synced including mail, website files and passwords.
  * Do not specify a remote directory in this case to download everything. If you only need `public_html` then navigate to the corresponding directory and specify the remote directory in the same way.
