(add-hook 'world-post-change-hook
	  (lambda () 
					; from the dos command line /w will alwayse take you there
	    (write-region 
	     (concat "cd " (w32-canonify (expand-file-name (fw)))) nil (expand-file-name "/w.cmd"))
					; from the desktop -- only do this for worlds you actually enter

	    (shell-command 
	     (format "shortcut -f -t \"%s\" -n \"%s/%s\" %s " 
		     (w32-canonify (fw) t) 
		     (w32-canonify (concat userprofile "/desktop"))
		     (wa)
		     (if nil		; (-f *tw-ico-file*)
			 (format "-i \"%s\"" *tw-ico-file*)
		       (format "-i \"%s\" -x \"%d\""
			       (w32-canonify (substitute-in-file-name "$SystemRoot/SYSTEM32/shell32.dll"))
			       13))
		     )
	     )
	    )
	  )
