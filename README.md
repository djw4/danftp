# danFTP
> "An almost fully automatic FTP based website migrating tool"

#### What does this mean?
* Requires only 1 package to operate (lftp)
* Requires only FTP access to a remote server to operate successfully
* Operates like rsync in that it syncs remote-local in an incremental fashion very quickly, downloading only new or updated files.
* Native functionality to re-run a previous migration again if you need to update the local file system.
