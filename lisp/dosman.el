(defconst rcs-id "$Id: dosman.el,v 1.2 2000-07-30 21:07:45 andy Exp $")
(provide 'dosman)

(setq doshelp '(
								("ASSOC"    "Displays or modifies file extension associations")
								("AT"       "Schedules commands and programs to run on a computer.")
								("ATTRIB"   "Displays or changes file attributes.")
								("BREAK"    "Sets or clears extended CTRL+C checking.")
								("CACLS"    "Displays or modifies access control lists (ACLs) of files.")
								("CALL"     "Calls one batch program from another.")
								("CD"       "Displays the name of or changes the current directory.")
								("CHCP"     "Displays or sets the active code page number.")
								("CHDIR"    "Displays the name of or changes the current directory.")
								("CHKDSK"   "Checks a disk and displays a status report.")
								("CLS"      "Clears the screen.")
								("CMD"      "Starts a new instance of the Windows NT command interpreter.")
								("COLOR"    "Sets the default console foreground and background colors.")
								("COMP"     "Compares the contents of two files or sets of files.")
								("COMPACT"  "Displays or alters the compression of files on NTFS partitions.")
								("CONVERT"  "Converts FAT volumes to NTFS.  You cannot convert the current drive.")
								("COPY"     "Copies one or more files to another location.")
								("DATE"     "Displays or sets the date.")
								("DEL"      "Deletes one or more files.")
								("DIR"      "Displays a list of files and subdirectories in a directory.")
								("DISKCOMP" "Compares the contents of two floppy disks.")
								("DISKCOPY" "Copies the contents of one floppy disk to another.")
								("DOSKEY"   "Edits command lines, recalls Windows NT commands, and creates macros.")
								("ECHO"     "Displays messages, or turns command echoing on or off.")
								("ENDLOCAL" "Ends localization of environment changes in a batch file.")
								("ERASE"    "Deletes one or more files.")
								("EXIT"     "Quits the CMD.EXE program (command interpreter).")
								("FC"       "Compares two files or sets of files, and displays the differences between them.")
								("FIND"     "Searches for a text string in a file or files.")
								("FINDSTR"  "Searches for strings in files.")
								("FOR"      "Runs a specified command for each file in a set of files.")
								("FORMAT"   "Formats a disk for use with Windows NT.")
								("FTYPE"    "Displays or modifies file types used in file extension associations.")
								("GOTO"     "Directs the Windows NT command interpreter to a labeled line in a batch program.")
								("GRAFTABL" "Enables Windows NT to display an extended character set in graphics mode.")
								("HELP"     "Provides Help information for Windows NT commands.")
								("IF"       "Performs conditional processing in batch programs.")
								("KEYB"     "Configures a keyboard for a specific language.")
								("LABEL"    "Creates, changes, or deletes the volume label of a disk.")
								("MD"       "Creates a directory.")
								("MKDIR"    "Creates a directory.")
								("MODE"     "Configures a system device.")
								("MORE"     "Displays output one screen at a time.")
								("MOVE"     "Moves one or more files from one directory to another directory on the same drive.")
								("PATH"     "Displays or sets a search path for executable files.")
								("PAUSE"    "Suspends processing of a batch file and displays a message.")
								("POPD"     "Restores the previous value of the current directory saved by PUSHD.")
								("PRINT"    "Prints a text file.")
								("PROMPT"   "Changes the Windows NT command prompt.")
								("PUSHD"    "Saves the current directory then changes it.")
								("RD"       "Removes a directory.")
								("RECOVER"  "Recovers readable information from a bad or defective disk.")
								("REM"      "Records comments (remarks) in batch files or CONFIG.SYS.")
								("REN"      "Renames a file or files.")
								("RENAME"   "Renames a file or files.")
								("REPLACE"  "Replaces files.")
								("RESTORE"  "Restores files that were backed up by using the BACKUP command.")
								("RMDIR"    "Removes a directory.")
								("SET"      "Displays, sets, or removes Windows NT environment variables.")
								("SETLOCAL" "Begins localization of environment changes in a batch file.")
								("SHIFT"    "Shifts the position of replaceable parameters in batch files.")
								("SORT"     "Sorts input.")
								("START"    "Starts a separate window to run a specified program or command.")
								("SUBST"    "Associates a path with a drive letter.")
								("TIME"     "Displays or sets the system time.")
								("TITLE"    "Sets the window title for a CMD.EXE session.")
								("TREE"     "Graphically displays the directory structure of a drive or path.")
								("TYPE"     "Displays the contents of a text file.")
								("VER"      "Displays the Windows NT version.")
								("VERIFY"   "Tells Windows NT whether to verify that your files are written correctly to a disk.")
								("VOL"      "Displays a disk volume label and serial number.")
								("XCOPY"    "Copies files and directory trees.")
								))

(defun dos-help (cmd &optional long) 
	(interactive (list (completing-read "Command: " doshelp)))
	(let ((s (assoc (upcase cmd)  doshelp)))
		(cond 
		 ((and s (not long)) (message (cadr s)))
		 (s (prog1 (pop-to-buffer 
								(let ((b (zap-buffer "*DOS Help*")))
									(call-process "cmd" nil b nil "/c" "help" cmd)
									b))
					(goto-char (point-min))
					(setq buffer-read-only t))))))
