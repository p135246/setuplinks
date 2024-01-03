# Setuplinks
## About
The [Bash](https://www.gnu.org/software/bash/) script `setuplinks.sh` creates a symbolink link for each line `LINKNAME;TARGET;...` of an input file.

The anticipated scenario involves a user who has some "global" folders synced with cloud (e.g., `~/OneDrive`, `~/Dropbox`, or `~/GoogleDrive` using [Insync](https://www.insynchq.com/)) and wants to link multiple of their subfiles and subfolders in the local file system separately.
For example, instead of remembering and running
```bash
     ln -s ~/OneDrive/dotfiles/bashrc ~/.bashrc
     ln -s ~/GoogleDrive/signature.svg ~/Pictures/signature.svg
     ln -s ~/Dropbox/shared/collaborators/paper1 ~/papers/paper1
```
each time the user wants to set up his file hierarchy, he creates a file `setuplinks.csv` that contains the lines
```csv
     # OneDrive
     ~/.bashrc;~/OneDrive/dotfiles/bashrc
     # GoogleDrive
     ~/Pictures/signature.svg;~/GoogleDrive/signature.svg
     # Dropbox
     ~/papers/paper1;~/Dropbox/shared/collaborators/paper1
```
(where each line to be ignored by the programm must be prepended with `#`) and runs
```bash
setuplinks.sh setuplinks.csv
```
The script offers various modes of interaction and a backup solution.

The following help is obtained by running `setuplinks.sh -h`.
## Help
### NAME:
   setuplinks
### SYNTAX:
   setuplinks [-b|d|f|h|i|r|s|v] FILE
### DESCRIPTION:
   Creates a symbolink link `LINKNAME->TARGET` for each line of `FILE`
   in the form `LINKNAME;TARGET`. Only lines starting with `#` are ignored.
   By defualt, the interactive mode of `ln` is invoked (asks before 
   replacement) and the progress is printed.
### MODIFIERS:
   * **-b**	Backup: If `LINKNAME` exists, it is moved to `LINKNAME.bck` (in the same folder).
          
   * **-d**	Dry run: Does not make any changes on files.
   
   * **-f**	Non-interactive mode of `ln`: If `LINKNAME` exists, it is 
            deleted without confirmation.
   
   * **-h**	Prints this help.
   
   * **-i**	Interactive mode: Requires confirmation before every file operation.
  
   * **-r**	Restore: If `LINKNAME.bck` exists, it is switched with `LINKNAME`.
 
   * **-s**	Silent  mode: Does not print out any progress.
   
   * **-v**	Verbose mode: Prints out each file-command.
### AUTHOR:
   Written by Pavel Hajek.
### COPYRIGHT
   MIT License © 2021 Pavel Hajek
   
