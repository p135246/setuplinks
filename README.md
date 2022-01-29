# Setuplinks
## About
The command `setuplinks input-file` creates a batch of symbolic links according to a given file `input-file` which contains on each line a target name and a link name relative to the home directory separated by TAB (use `#` at the beginning of the line to make a comment).
It is useful to link files and folders in various cloud drives to the local machine when setting up a new computer and helps with organization.
For example, instead of running
```
     ln -s ~/Dropbox/dotfiles/bashrc ~/.bashrc
     ln -s ~/OneDrive/Signature ~/Pictures/signature
```
one creates a file `my-links` containing
```
     # Dropbox
     Dropbox/dotfiles/bashrc	.bashrc
     # OneDrive
     OneDrive/Signature		Pictures/signature
```
and runs `setuplinks my-links`.
Moreover, one can add the option `-b` to backup existing files or the option `-r` to revert files from backups.
## Manual
### NAME:
   setuplinks
### SYNTAX:
   setuplinks [-b|d|f|h|i|r|s|v] CONTROLFILE
### DESCRIPTION:
   Creates symbolink links TARGET<-LINKNAME as specified in the
   CONTROLFILE in two tab-separated columns relative to the user's HOME directory.
   Runs 'ln' in the interactive mode and prints out progress by default.
   
   * **-b**       If LINKNAME exists, it is moved to LINKNAME.bck.
                  If LINKNAME.bck exists, it is moved to LINKNAME.bck~
          
   * **-d**    Dry run.
   
   * **-f**     If LINKNAME exists, it is deleted without confirmation.
   
   * **-h**     Prints this help.
   
   * **-i**     Asks for confirmation before every file operation.
  
   * **-r**     Revert changes by replacing LINKNAME with LINKNAME.bck
 
   * **-s**     Silent  mode. Does not print out progress.
   
   * **-v**     Verbose mode. Prints out every file operation.
   
