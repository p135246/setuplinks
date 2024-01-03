# Setuplinks
## About
The [Bash](https://www.gnu.org/software/bash/) script `setuplinks.sh` creates a symbolic link for each line `LINKNAME;TARGET;...` of an input file.

The anticipated scenario involves a user who has some "global" folders synced with the cloud (e.g., I have `~/OneDrive`, `~/Dropbox`, and `~/GoogleDrive` synced with the corresponding clouds by [Insync](https://www.insynchq.com/)) and wants to link multiple of their subfiles and subfolders in the local file system separately.
For example, instead of remembering and running
```bash
     ln -s ~/OneDrive/dotfiles/bashrc ~/.bashrc
     ln -s ~/GoogleDrive/signature.svg ~/Pictures/signature.svg
     ln -s ~/Dropbox/shared/collaborators/paper1 ~/papers/paper1
```
each time the user sets up his file hierarchy, he creates a file `setuplinks.csv` that contains the lines
```csv
     # OneDrive
     ~/.bashrc;~/OneDrive/dotfiles/bashrc
     # GoogleDrive
     ~/Pictures/signature.svg;~/GoogleDrive/signature.svg
     # Dropbox
     ~/papers/paper1;~/Dropbox/shared/collaborators/paper1
```
and runs
```bash
setuplinks.sh setuplinks.csv
```
Note that each line of the input file which is meant to be ignored by the program must be prepended with `#`.
The script offers various modes of interaction and a backup solution.

The following help is obtained by running `setuplinks.sh -h`.
## Help
### NAME:
   setuplinks
### SYNTAX:
   setuplinks [-b|d|f|h|i|r|s|v|V] FILE
### DESCRIPTION:
   Creates a symbolink link `LINKNAME->TARGET` for each line of `FILE`
   in the form `LINKNAME;TARGET`. Only lines starting with `#` are ignored.
   By default, the interactive mode of `ln` is invoked (asks before 
   replacement) and the progress is printed. The modifiers can be combined
   as `-b -f -s` (`-bfs` does not work).

### MODIFIERS:
   * **-b**	Backup: If `LINKNAME` exists, it is moved to `LINKNAME.bck` (in the same folder).
          
   * **-d**	Dry run: Does not make any changes on files.
   
   * **-f**	Non-interactive mode of `ln`: If `LINKNAME` exists, it is replaced by the newly created symlink without any confirmation.
                If combined with **-b**, the backup `LINKNAME.bck` is created before the replacement. 
   * **-h**	Prints this help and quits.
   
   * **-i**	Interactive mode: Requires confirmation before every file operation.
  
   * **-r**	Restore: If `LINKNAME.bck` exists, it is switched with `LINKNAME`.
 
   * **-s**	Silent  mode: Does not print any progress.
   
   * **-v**	Prints the version and quits.
   
   * **-V**	Verbose mode: Prints out each file-command.
### AUTHOR:
   Pavel Hajek.
### COPYRIGHT
   MIT License © 2021 Pavel Hajek
   
