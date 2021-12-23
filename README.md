### NAME:
   setuplinks
### SYNTAX:
   setuplinks [-b|d|f|h|i] CONTROLFILE
### DESCRIPTION:
   Creates symbolink links TARGET<-LINKNAME as specified in the
   CONTROLFILE in two tab-separated columns. Runs 'ln' in the
   interactive mode by default.
   
   * **-b**       If LINKNAME exists, it is moved to LINKNAME.bck.
                  If LINKNAME.bck exists, it is moved to LINKNAME.bck~
          
   * **-d**    Dry run.
   
   * **-f**     If LINKNAME exists, it is deleted without confirmation.
   
   * **-h**     Prints this help.
   
   * **-i**     Asks for confirmation before every file operation.
   
   * **-v**     Verbose mode. Prints out every file operation.
   
   * **-s**     Silent  mode. Does not print out progress and warnings.
