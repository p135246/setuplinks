# Setuplinks
## About
The BASH script `setuplinks` creates a batch of symbolic links according to a two-columns list in a given file.
It is useful to link files and folders in various cloud drives to the local machine, e.g., `ln -s ~/Dropbox/dotfiles/bashrc ~/.bashrc`.
Moreover, `setuplinks` has an option to create backups of existing files and revert changes.
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
   
